import Foundation
import LaunchdManager

public final class CalciferBinaryInstallerImpl: CalciferBinaryInstaller {
    
    private let fileManager: FileManager
    private let launchdManager: LaunchdManager
    
    public init(fileManager: FileManager, launchdManager: LaunchdManager) {
        self.fileManager = fileManager
        self.launchdManager = launchdManager
    }
    
    public func install(binaryPath: String, destinationPath: String) throws {
        let plist = LaunchdPlist.daemonPlist(programPath: destinationPath)
        let plistPath = fileManager.launchctlPlistPath(label: plist.label)
        try launchdManager.unloadPlistFromLaunchctl(plistPath: plistPath)
        if fileManager.fileExists(atPath: destinationPath) {
            try fileManager.removeItem(atPath: destinationPath)
        }
        let destinationDirectory = destinationPath.deletingLastPathComponent()
        if fileManager.directoryExist(at: destinationDirectory) == false {
            try fileManager.createDirectory(
                atPath: destinationDirectory,
                withIntermediateDirectories: true
            )
        }
        try fileManager.copyItem(
            atPath: binaryPath,
            toPath: destinationPath
        )
        try launchdManager.loadPlistToLaunchctl(plist: plist, plistPath: plistPath)
    }
}
