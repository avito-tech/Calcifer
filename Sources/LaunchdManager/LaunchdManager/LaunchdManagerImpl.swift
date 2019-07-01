import Foundation
import ShellCommand
import Toolkit

public final class LaunchdManagerImpl: LaunchdManager {
    
    private let fileManager: FileManager
    private let shellExecutor: ShellCommandExecutor
    private let userIdentifierProvider: UserIdentifierProvider
    
    public init(
        fileManager: FileManager,
        shellExecutor: ShellCommandExecutor,
        userIdentifierProvider: UserIdentifierProvider)
    {
        self.fileManager = fileManager
        self.shellExecutor = shellExecutor
        self.userIdentifierProvider = userIdentifierProvider
    }
    
    public func loadPlistToLaunchctl(plist: LaunchdPlist, plistPath: String) throws {
        try unloadPlistFromLaunchctl(plist: plist, plistPath: plistPath)
        try fileManager.write(plist.content, to: plistPath)
        try createOutputDirectory(plist.standardOutPath.deletingLastPathComponent())
        try createOutputDirectory(plist.standardErrorPath.deletingLastPathComponent())
        let userId = try userIdentifierProvider.currentUserIdentifier()
        let enableCommand = LaunchctlShellCommand(
            plist: plist,
            plistPath: plistPath,
            type: .enable,
            domain: .user(userId: userId)
        )
        let enableResult = shellExecutor.execute(command: enableCommand)
        Logger.verbose("Launchctl enable command \(enableCommand) completed with result \(enableResult)")
        let loadCommand = LaunchctlShellCommand(
            plist: plist,
            plistPath: plistPath,
            type: .load,
            domain: .user(userId: userId)
        )
        let loadResult = shellExecutor.execute(command: loadCommand)
        Logger.verbose("Launchctl load command \(loadCommand) completed with result \(loadResult)")
        if loadResult.terminationStatus != 0 {
            throw LaunchdManagerError.failedToLoadPlistToLaunchctl(error: loadResult.error)
        }
    }
    
    private func createOutputDirectory(_ path: String) throws {
        guard fileManager.directoryExist(at: path) else {
            try fileManager.createDirectory(
                atPath: path,
                withIntermediateDirectories: true
            )
            return
        }
    }
    
    public func unloadPlistFromLaunchctl(plist: LaunchdPlist, plistPath: String) throws {
        let userId = try userIdentifierProvider.currentUserIdentifier()
        let unloadCommand = LaunchctlShellCommand(
            plist: plist,
            plistPath: plistPath,
            type: .unload,
            domain: .user(userId: userId)
        )
        let result = shellExecutor.execute(command: unloadCommand)
        Logger.verbose("Launchctl unload command \(unloadCommand) completed with result \(result)")
    }
    
}
