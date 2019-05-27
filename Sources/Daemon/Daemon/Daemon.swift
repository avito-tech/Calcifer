import Foundation
import ArgumentsParser
import Swifter
import Toolkit

public final class Daemon {
    
    private let server = HttpServer()
    private let commandRunner: CommandRunner
    private let commandRunQueue = DispatchQueue(label: "DaemonCommandRunQueue")
    
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
        })
        try server.start(9080)
        RunLoop.main.run()
    }
    
    private func executeCommand(config: CommandRunConfig, for session: WebSocketSession) {
        // Calcifer cannot perform multiple build at the same time.
        commandRunQueue.sync {
            redirectLogs(to: session)
            redirectStandardStream(to: session)
            
            let code = self.commandRunner.run(config: config)
            Logger.verbose("Command run result \(code)")
            
            clearLogsRedirect()
            clearStandardStreamRedirect()
            
            let codeMessage = CommandRunCodeMessage (code: code)
            session.write(codeMessage)
            session.writeCloseFrame()
        }
    }
    
    private func redirectLogs(to session: WebSocketSession) {
        let destination = CustomLoggerDestination(onNewMessage: { message in
            session.write(message)
        })
        Logger.addDestination(destination)
    }
    
    private func clearLogsRedirect() {
        Logger.removeAllDestination()
        Logger.addConsoleDestination()
    }
    
    private func redirectStandardStream(to session: WebSocketSession) {
        StandardStreamWrapper.shared.onOutputWrite = { data in
            let message = StandardStreamMessage(source: .output, data: data)
            session.write(message)
        }
        StandardStreamWrapper.shared.onErrorWrite = { data in
            let message = StandardStreamMessage(source: .error, data: data)
            session.write(message)
        }
    }
    
    private func clearStandardStreamRedirect() {
        StandardStreamWrapper.shared.onOutputWrite = nil
        StandardStreamWrapper.shared.onErrorWrite = nil
    }
    
}
