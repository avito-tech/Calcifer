import Foundation
import LaunchdManager

public protocol CalciferBinaryInstaller {
    func install(
        binaryPath: String,
        destinationBinaryPath: String,
        plist: LaunchdPlist,
        plistPath: String) throws
}
