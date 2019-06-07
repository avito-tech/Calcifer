import Foundation

public protocol LaunchdManager {
    func loadPlistToLaunchctl(plist: LaunchdPlist, plistPath: String) throws
    func unloadPlistFromLaunchctl(plistPath: String) throws
}
