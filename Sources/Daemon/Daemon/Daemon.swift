import Foundation
import ArgumentsParser
import DaemonModels
import Swifter
import Toolkit

public final class Daemon {
    
    private let server = HttpServer()
    private let commandRunner: CommandRunner
    private let commandRunQueue = DispatchQueue(
        label: "DaemonCommandRunQueue",
        qos: .userInitiated
    )
    private let serverPort = 9080
    
    public init(commandRunner: CommandRunner) {
        self.commandRunner = commandRunner
    }
    
    public func run() throws {
        Logger.disableFileLog()
        server["/daemon"] = websocket(text: { session, text in
            let arguments = text.chop().split(separator: " ").map { String($0) }
            let config = CommandRunConfig(arguments: arguments)
            self.executeCommand(config: config, for: session)
        }, binary: { session, binary in
            let data = Data(bytes: binary)
            let decoder = JSONDecoder()
            let config = catchError { try decoder.decode(CommandRunConfig.self, from: data) }
            self.executeCommand(config: config, for: session)
        },
        disconnected: { session in
            self.clearLogsRedirect()
            self.clearStandardStreamRedirect()
        })
        try server.start(in_port_t(serverPort))
        RunLoop.main.run()
    }
    
    private func executeCommand(config: CommandRunConfig, for session: WebSocketSession) {
        // It is very important that this code is asynchronous. ( PERFORMANCE )
        commandRunQueue.async {
            self.redirectLogs(to: session)
            self.redirectStandardStream(to: session)
            
            Logger.info("Start execute command \(config.arguments)")
            let code = TimeProfiler.measure("Execute command") {
                self.commandRunner.run(config: config)
            }
            Logger.info("Command run result \(code)")
            
            self.clearLogsRedirect()
            self.clearStandardStreamRedirect()
            
            let codeMessage = CommandExitCodeMessage(code: code)
            session.write(DaemonMessage.exitCode(codeMessage))
            session.writeCloseFrame()
        }
    }
    
    private func redirectLogs(to session: WebSocketSession) {
        let destination = CustomLoggerDestination(onNewMessage: { message in
            session.write(DaemonMessage.logger(message))
        })
        Logger.addDestination(destination)
    }
    
    private func clearLogsRedirect() {
        Logger.removeAllDestinations()
        Logger.addConsoleDestination()
    }
    
    private func redirectStandardStream(to session: WebSocketSession) {
        ObservableStandardStream.shared.onOutputWrite = { data in
            let message = StandardStreamMessage(source: .output, data: data)
            session.write(DaemonMessage.standardStream(message))
        }
        ObservableStandardStream.shared.onErrorWrite = { data in
            let message = StandardStreamMessage(source: .error, data: data)
            session.write(DaemonMessage.standardStream(message))
        }
    }
    
    private func clearStandardStreamRedirect() {
        ObservableStandardStream.shared.onOutputWrite = nil
        ObservableStandardStream.shared.onErrorWrite = nil
    }
    
}
