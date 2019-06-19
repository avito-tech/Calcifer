import Foundation

public protocol LaunchdManager {
    func loadPlistToLaunchctl(plist: LaunchdPlist, plistPath: String) throws
    func unloadPlistFromLaunchctl(plist: LaunchdPlist, plistPath: String) throws
}
