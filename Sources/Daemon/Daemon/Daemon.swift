import Foundation
import ArgumentsParser
import DaemonModels
import Warmer
import Swifter
import Toolkit

public final class Daemon {
    
    private let server = HttpServer()
    private let commandRunner: CommandRunner
    private let warmerManager: WarmerManager

    private let commandRunOperationQueue: OperationQueue
    private let serverPort = 9080
    private let warmerDebouncer = Debouncer(delay: 120)
    
    var commandStateHolder: CommandStateHolder?
    var sessionWriter: WebSocketSessionWriter?
    
    public init(
        commandRunOperationQueue: OperationQueue,
        commandRunner: CommandRunner,
        warmerManager: WarmerManager)
    {
        self.commandRunOperationQueue = commandRunOperationQueue
        self.commandRunner = commandRunner
        self.warmerManager = warmerManager
    }
    
    public func run() throws {
        Logger.disableFileLog()
        server["/daemon"] = websocket(text: { session, text in
            let arguments = text.chop().split(separator: " ").map { String($0) }
            let config = CommandRunConfig(
                identifier: UUID().uuidString,
                arguments: arguments
            )
            self.executeCommand(config: config, for: session)
        }, binary: { session, binary in
            
            if self.sessionWriter?.session != session {
                Logger.warning("Multiple daemon connections")
                return
            }
            
            let data = Data(bytes: binary)
            let decoder = JSONDecoder()
            Logger.info("Daemon receive data")
            do {
                let config = try decoder.decode(CommandRunConfig.self, from: data)
                self.executeCommand(config: config, for: session)
            } catch let error {
                Logger.warning("Failed execute command with error \(error)")
                self.commandStateHolder?.state = .completed(exitCode: 1)
                self.sendExitCommand(code: 1)
            }
        },
        connected: { session in
            
            let sessionWriter: WebSocketSessionWriter
            if let currentSessionWriter = self.sessionWriter,
                currentSessionWriter.session == session
            {
                sessionWriter = currentSessionWriter
            } else {
                sessionWriter = WebSocketSessionWriter(session: session)
                self.sessionWriter = sessionWriter
            }
            
            sessionWriter.state = .active
            
            self.redirectLogs(to: sessionWriter)
            self.redirectStandardStream(to: sessionWriter)
            Logger.info("Daemon receive connection")
        },
        disconnected: { session in
            self.clearLogsRedirect()
            self.clearStandardStreamRedirect()
            if let currentSessionWriter = self.sessionWriter,
                currentSessionWriter.session == session
            {
                currentSessionWriter.state = .suspended
            }
        })
        try server.start(in_port_t(serverPort))
        warmerManager.start()
        RunLoop.main.run()
    }
    
    private func executeCommand(config: CommandRunConfig, for session: WebSocketSession) {
        // It is very important that this code is asynchronous. ( PERFORMANCE )
        let operation = BlockOperation {
            
            if let currentCommandStateHolder = self.commandStateHolder,
                currentCommandStateHolder.commandIdentifier == config.identifier
            {
                switch currentCommandStateHolder.state {
                case .running:
                    Logger.warning("Command \(config) already in progress")
                case let .completed(exitCode):
                    Logger.warning("Command \(config) already completed with exit code \(exitCode)")
                    self.sendExitCommand(code: exitCode)
                }
                return
            }
            
            self.commandStateHolder = CommandStateHolder(
                commandIdentifier: config.identifier,
                state: .running
            )
            Logger.info("Start execute command \(config)")
            let code = TimeProfiler.measure("Execute command") {
                self.commandRunner.run(config: config)
            }
            self.commandStateHolder?.state = .completed(exitCode: code)
            Logger.info("Command run result \(code)")
            
            self.sendExitCommand(code: code)
            self.warmerDebouncer.debounce {
                self.warmerManager.warmup()
            }
        }
        operation.queuePriority = .veryHigh
        commandRunOperationQueue.addOperation(operation)
    }
    
    private func sendExitCommand(code: Int32) {
        guard let sessionWriter = self.sessionWriter else {
            return
        }
        let codeMessage = CommandExitCodeMessage(code: code)
        sessionWriter.write(DaemonMessage.exitCode(codeMessage))
    }
    
    private func redirectLogs(to writer: WebSocketSessionWriter) {
        let destination = CustomLoggerDestination(onNewMessage: { message in
            writer.write(DaemonMessage.logger(message))
        })
        Logger.addDestination(destination)
    }
    
    private func clearLogsRedirect() {
        Logger.removeAllDestinations()
        Logger.addConsoleDestination()
    }
    
    private func redirectStandardStream(to writer: WebSocketSessionWriter) {
        ObservableStandardStream.shared.onOutputWrite = { data in
            let message = StandardStreamMessage(source: .output, data: data)
            writer.write(DaemonMessage.standardStream(message))
        }
        ObservableStandardStream.shared.onErrorWrite = { data in
            let message = StandardStreamMessage(source: .error, data: data)
            writer.write(DaemonMessage.standardStream(message))
        }
    }
    
    private func clearStandardStreamRedirect() {
        ObservableStandardStream.shared.onOutputWrite = nil
        ObservableStandardStream.shared.onErrorWrite = nil
    }
    
}
