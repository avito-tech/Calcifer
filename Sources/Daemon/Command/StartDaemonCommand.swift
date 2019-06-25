import Foundation
import ArgumentsParser
import ShellCommand
import SPMUtility
import Warmer
import Toolkit

public final class StartDaemonCommand: Command {
    
    public let command = "startDaemon"
    public let overview = "Start daemon with sever"
    
    public required init(parser: ArgumentParser) {
        parser.add(subparser: command, overview: overview)
    }
    
    public func run(with arguments: ArgumentParser.Result, runner: CommandRunner) throws {
        // If another daemon instance is already running, new instance will die because socket is already reserved/busy
        Logger.info("Run daemon pid \(getpid())")
        
        let operationQueue = OperationQueue.createSerialQueue(
            qualityOfService: .userInitiated
        )
        let fileManager = FileManager.default
        let warmerFactory = WarmerManagerFactory(
            fileManager: fileManager
        )
        let warmerManager = warmerFactory.createWarmerManager(
            warmupOperationQueue: operationQueue
        )
        let daemon = Daemon(
            commandRunOperationQueue: operationQueue,
            commandRunner: runner,
            warmerManager: warmerManager
        )
        try daemon.run()
    }
    
}
