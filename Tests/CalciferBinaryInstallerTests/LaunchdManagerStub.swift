import Foundation
import LaunchdManager

class LaunchdManagerStub: LaunchdManager {
    
    var onLoadPlist: ((LaunchdPlist, String) -> ())? = nil
    func loadPlistToLaunchctl(plist: LaunchdPlist, plistPath: String) throws {
        onLoadPlist?(plist, plistPath)
    }
    
    var onUnloadPlist: ((LaunchdPlist, String) -> ())? = nil
    func unloadPlistFromLaunchctl(plist: LaunchdPlist, plistPath: String) throws {
        onUnloadPlist?(plist, plistPath)
    }
    
}
