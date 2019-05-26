import Foundation
import AppKit
import XcodeBuildEnvironmentParametersParser
import BuildProductCacheStorage
import ArgumentsParser
import Foundation
import ShellCommand
import Utility
import Toolkit

public final class StartDaemonCommand: Command {
    
    public let command = "startDaemon"
    public let overview = "Start daemon"
    
    public required init(parser: ArgumentParser) {
        let _ = parser.add(subparser: command, overview: overview)
    }
    
    public func run(with arguments: ArgumentParser.Result, runner: CommandRunner) throws {
        // If another process of daemon will be run then it die because socket already reserved
        Logger.info("Run daemon pid \(getpid())")
        try Daemon(commandRunner: runner).run()
    }
    
}

