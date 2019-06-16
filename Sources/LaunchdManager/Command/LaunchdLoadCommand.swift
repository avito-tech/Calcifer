import Foundation
import ArgumentsParser
import Foundation
import ShellCommand
import SPMUtility
import Toolkit

public final class LaunchdLoadCommand: Command {
    
    public let command = "launchdLoad"
    public let overview = "Generate a plist and pass it to launchctl that starts the server and will keep it up all the time."
    
    public required init(parser: ArgumentParser) {
        parser.add(subparser: command, overview: overview)
    }
    
    public func run(with arguments: ArgumentParser.Result, runner: CommandRunner) throws {
        guard let programPath = ProcessInfo.processInfo.arguments.first else {
            return
        }
        let plist = LaunchdPlist.daemonPlist(programPath: programPath)
        let fileManager = FileManager.default
        let launchdManager = LaunchdManagerImpl(
            fileManager: fileManager,
            shellExecutor: ShellCommandExecutorImpl()
        )
        let plistPath = fileManager.launchctlPlistPath(label: plist.label)
        try launchdManager.loadPlistToLaunchctl(
            plist: plist,
            plistPath: plistPath
        )
    }
    
}
