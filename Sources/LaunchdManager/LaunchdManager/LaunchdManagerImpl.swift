import Foundation
import ShellCommand
import Toolkit

public final class LaunchdManagerImpl: LaunchdManager {
    
    private let fileManager: FileManager
    private let shellExecutor: ShellCommandExecutor
    
    public init(
        fileManager: FileManager,
        shellExecutor: ShellCommandExecutor)
    {
        self.fileManager = fileManager
        self.shellExecutor = shellExecutor
    }
    
    public func loadPlistToLaunchctl(plist: LaunchdPlist, plistPath: String) throws {
        try unloadPlistFromLaunchctl(plist: plist, plistPath: plistPath)
        try fileManager.write(plist.content, to: plistPath)
        try createOutputDirectory(plist.standardOutPath.deletingLastPathComponent())
        try createOutputDirectory(plist.standardErrorPath.deletingLastPathComponent())
        let loadCommand = LaunchctlShellCommand(
            plistPath: plistPath,
            type: .load,
            sessionType: plist.sessionType
        )
        let result = shellExecutor.execute(command: loadCommand)
        Logger.verbose("Launchctl load with result \(result)")
        if result.terminationStatus != 0 {
            throw LaunchdManagerError.failedToLoadPlistToLaunchctl(error: result.error)
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
        let unloadCommand = LaunchctlShellCommand(
            plistPath: plistPath,
            type: .unload,
            sessionType: plist.sessionType
        )
        let result = shellExecutor.execute(command: unloadCommand)
        Logger.verbose("Launchctl unload with result \(result)")
    }
    
}
