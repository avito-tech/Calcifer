import Foundation
import ShellCommand

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
        try unloadPlistFromLaunchctl(plistPath: plistPath)
        try fileManager.write(plist.content, to: plistPath)
        let loadCommand = LaunchctlShellCommand(plistPath: plistPath, type: .load)
        let result = shellExecutor.execute(command: loadCommand)
        if result.terminationStatus != 0 {
            throw LaunchdManagerError.failedToLoadPlistToLaunchctl(error: result.error)
        }
    }
    
    public func unloadPlistFromLaunchctl(plistPath: String) throws {
        let unloadCommand = LaunchctlShellCommand(
            plistPath: plistPath,
            type: .unload
        )
        let result = shellExecutor.execute(command: unloadCommand)
        if result.terminationStatus != 0 {
            throw LaunchdManagerError.failedToUnloadPlistToLaunchctl(error: result.error)
        }
    }
    
}
