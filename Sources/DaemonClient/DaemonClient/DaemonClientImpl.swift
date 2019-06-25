import Foundation
import Starscream
import DaemonModels
import ArgumentsParser
import Toolkit

public final class DaemonClientImpl: DaemonClient {
    
    private lazy var socket = WebSocket(url: daemonURL)
    private let daemonURL: URL
    private let dispatchGroup = DispatchGroup()
    private let callbackQueue = DispatchQueue(
        label: "DaemonClientQueue",
        qos: .userInitiated
    )
    
    public init(daemonURL: URL) {
        self.daemonURL = daemonURL
        socket.callbackQueue = callbackQueue
    }
    
    public func sendToDaemon(commandRunConfig: CommandRunConfig) throws {
        let commandData = try commandRunConfig.encode()
        var exitCode: Int32?
        setupSocketCallbacks(
            onConnect: {
                Logger.info("websocket is connected")
                Logger.info("Send command \(commandRunConfig.arguments) to daemon")
                self.socket.write(data: commandData)
            },
            onDisconnect: { error in
                if let exitCode = exitCode {
                    Logger.verbose("Work completed with exit code \(exitCode)")
                    if exitCode != 0 {
                        exit(exitCode)
                    }
                    Logger.info("Work successfully completed")
                    self.dispatchGroup.leave()
                    return
                }
                if let error = error {
                    Logger.info("Socket was disconnected with error \(error)")
                    // Reconnect on specific error
                    if let wsError = error as? WSError,
                        wsError.type == .protocolError,
                        wsError.code == 1002
                    {
                        Logger.info("Reconnect to socket")
                        self.socket.connect()
                    } else if (error as NSError).code == 61 {
                        Logger.info("Daemon not started")
                        exit(1)
                    } else {
                        exit(1)
                    }
                } else {
                    Logger.info("Socket was disconnected without error and exit code")
                    Logger.info("Reconnect to socket")
                    self.socket.connect()
                }
            },
            onExitCodeMessage: { exitCodeMessage in
                exitCode = exitCodeMessage.code
                Logger.verbose("Client: Command \(commandRunConfig) completed with exit code \(exitCodeMessage.code)")
                self.socket.disconnect()
            }
        )
        Logger.info("Try to connect to daemon by socket \(daemonURL)")
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
