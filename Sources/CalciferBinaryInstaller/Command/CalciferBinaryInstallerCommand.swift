import Foundation
import ArgumentsParser
import LaunchdManager
import ShellCommand
import Foundation
import SPMUtility
import Toolkit

public final class CalciferBinaryInstallerCommand: Command {
    
    public let command = "installCalciferBinary"
    public let overview = "Install new Calcifer binary - move binary to calcifer binary path"
    
    enum Arguments: String, CommandArgument {
        case binaryPath
    }
    
    private let binaryPathArgument: OptionArgument<String>
    
    public required init(parser: ArgumentParser) {
        let subparser = parser.add(subparser: command, overview: overview)
        binaryPathArgument = subparser.add(
            option: Arguments.binaryPath.optionString,
            kind: String.self,
            usage: "Path to new binary"
        )
    }
    
    public func run(with arguments: ArgumentParser.Result, runner: CommandRunner) throws {
        
        let binaryPath: String
        if let binaryPathArgumentValue = arguments.get(self.binaryPathArgument) {
            binaryPath = binaryPathArgumentValue
        } else if let launchPath = ProcessInfo.processInfo.arguments.first {
            binaryPath = launchPath
        } else {
            throw ArgumentsError.argumentIsMissing(Arguments.binaryPath.rawValue)
        }
        

        let fileManager = FileManager.default
        let shellExecutor = ShellCommandExecutorImpl()
        let launchdManager = LaunchdManagerImpl(
            fileManager: fileManager,
            shellExecutor: shellExecutor
        )
        let installer = CalciferBinaryInstallerImpl(
            fileManager: fileManager,
            launchdManager: launchdManager
        )
        let calciferPathProvider = CalciferPathProviderImpl(fileManager: fileManager)
        let destinationBinaryPath = calciferPathProvider.calciferBinaryPath()
        let plist = LaunchdPlist.daemonPlist(
            programPath: destinationBinaryPath,
            standardOutPath: calciferPathProvider.launchctlStandardOutPath(),
            standardErrorPath: calciferPathProvider.launchctlStandardErrorPath()
        )
        let plistPath = calciferPathProvider.launchAgentPlistPath(label: plist.label)
        try installer.install(
            binaryPath: binaryPath,
            destinationBinaryPath: destinationBinaryPath,
            plist: plist,
            plistPath: plistPath
        )
    }
    
}
