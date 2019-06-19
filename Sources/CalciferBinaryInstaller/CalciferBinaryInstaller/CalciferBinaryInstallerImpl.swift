import Foundation
import LaunchdManager

public final class CalciferBinaryInstallerImpl: CalciferBinaryInstaller {
    
    private let fileManager: FileManager
    private let launchdManager: LaunchdManager
    
    public init(fileManager: FileManager, launchdManager: LaunchdManager) {
        self.fileManager = fileManager
        self.launchdManager = launchdManager
    }
    
    public func install(
        binaryPath: String,
        destinationBinaryPath: String,
        plist: LaunchdPlist,
        plistPath: String)
        throws
    {
        try launchdManager.unloadPlistFromLaunchctl(sessionType: plist.sessionType, plistPath: plistPath)
        if fileManager.fileExists(atPath: destinationBinaryPath) {
            try fileManager.removeItem(atPath: destinationBinaryPath)
        }
        let destinationDirectory = destinationBinaryPath.deletingLastPathComponent()
        if fileManager.directoryExist(at: destinationDirectory) == false {
            try fileManager.createDirectory(
                atPath: destinationDirectory,
                withIntermediateDirectories: true
            )
        }
        try fileManager.copyItem(
            atPath: binaryPath,
            toPath: destinationBinaryPath
        )
        try launchdManager.loadPlistToLaunchctl(plist: plist, plistPath: plistPath)
    }
}
