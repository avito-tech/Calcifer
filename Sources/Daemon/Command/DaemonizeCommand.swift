import Foundation
import AppKit
import XcodeBuildEnvironmentParametersParser
import BuildProductCacheStorage
import ArgumentsParser
import Foundation
import ShellCommand
import Utility
import Toolkit

public final class DaemonizeCommand: Command {
    
    public let command = "daemonize"
    public let overview = "Create plist and pass to launchctl"
    
    public required init(parser: ArgumentParser) {
        let _ = parser.add(subparser: command, overview: overview)
    }
    
    public func run(with arguments: ArgumentParser.Result, runner: CommandRunner) throws {
        let daemonizer = Daemonizer(
            fileManager: FileManager.default,
            shellExecutor: ShellCommandExecutorImpl()
        )
        daemonizer.daemonize()
    }
    
}
