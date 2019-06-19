import Foundation

public protocol LaunchdManager {
    func loadPlistToLaunchctl(plist: LaunchdPlist, plistPath: String) throws
    func unloadPlistFromLaunchctl(sessionType: LaunchdSessionType, plistPath: String) throws
}
