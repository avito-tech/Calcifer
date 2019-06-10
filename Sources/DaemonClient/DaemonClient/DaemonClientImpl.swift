import Foundation
import Starscream
import DaemonModels
import ArgumentsParser
import Toolkit
import SwiftyBeaver

public final class DaemonClientImpl: DaemonClient {
    
    private lazy var socket = WebSocket(url: daemonURL)
    private let daemonURL: URL
    private let dispatchGroup = DispatchGroup()
    private let callbackQueue = DispatchQueue(label: "DaemonClientQueue")
    
    init(daemonURL: URL) {
        self.daemonURL = daemonURL
    }
    
    public func sendToDaemon(commandRunConfig: CommandRunConfig) throws {
        socket.callbackQueue = callbackQueue
        let commandData = try commandRunConfig.encode()
        var exitCode: Int32? = nil
        setupSocketCallbacks(
            onConnect: {
                Logger.info("websocket is connected")
                Logger.info("Send command \(commandRunConfig.arguments) to daemon")
                self.socket.write(data: commandData)
            },
            onDisconnect: { error in
                guard let exitCode = exitCode else {
                    if let error = error {
                        Logger.info("Socket was disconnected with error \(error)")
                    } else {
                        Logger.info("Socket was disconnected")
                    }
                    exit(1)
                }
                if exitCode != 0 {
                    exit(exitCode)
                }
                self.dispatchGroup.leave()
            },
            onExitCodeMessage: { exitCodeMessage in
                exitCode = exitCodeMessage.code
                Logger.info("Command \(commandRunConfig) completed with exit code \(exitCodeMessage.code)")
                self.socket.disconnect()
            }
        )
        socket.connect()
        dispatchGroup.enter()
        dispatchGroup.wait()
    }
    
    private func setupSocketCallbacks(
        onConnect: @escaping () -> (),
        onDisconnect: @escaping (Error?) -> (),
        onExitCodeMessage: @escaping (CommandExitCodeMessage) -> ())
    {
        socket.onConnect = onConnect
        socket.onDisconnect = onDisconnect
        socket.onData = { (data: Data) in
            self.processSocketData(
                data: data,
                onExitCodeMessage: onExitCodeMessage
            )
        }
    }
    
    private func processSocketData(
        data: Data,
        onExitCodeMessage: (CommandExitCodeMessage) -> ())
    {
        guard let message: DaemonMessage = try? data.decode() else {
            return
        }
        switch message {
        case let .standardStream(standardStreamMessage):
            redirect(standardStreamMessage)
        case let .logger(LoggerMessage):
            redirect(LoggerMessage)
        case let .exitCode(exitCodeMessage):
            onExitCodeMessage(exitCodeMessage)
        }
    }
    
    private func redirect(_ standardStreamMessage: StandardStreamMessage) {
        switch standardStreamMessage.source {
        case .output:
            FileHandle.standardOutput.write(standardStreamMessage.data)
        case .error:
            FileHandle.standardError.write(standardStreamMessage.data)
        }
    }
    
    private func redirect(_ loggerMessage: LoggerMessage) {
        Logger.log(loggerMessage)
    }
}
