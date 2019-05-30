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
    // Look on StartDaemonCommand
    public let overview = "Generate a plist and pass it to launchctl that starts the server and will keep it up all the time."
    
    public required init(parser: ArgumentParser) {
        parser.add(subparser: command, overview: overview)
    }
    
    public func run(with arguments: ArgumentParser.Result, runner: CommandRunner) throws {
        let daemonizer = Daemonizer(
            fileManager: FileManager.default,
            shellExecutor: ShellCommandExecutorImpl()
        )
        daemonizer.daemonize()
    }
    
}
