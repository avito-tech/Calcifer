import Foundation
import LaunchdManager

class LaunchdManagerStub: LaunchdManager {
    
    var onLoadPlist: ((LaunchdPlist, String) -> ())? = nil
    func loadPlistToLaunchctl(plist: LaunchdPlist, plistPath: String) throws {
        onLoadPlist?(plist, plistPath)
    }
    
    var onUnloadPlist: ((String) -> ())? = nil
    func unloadPlistFromLaunchctl(plistPath: String) throws {
        onUnloadPlist?(plistPath)
    }
    
}
