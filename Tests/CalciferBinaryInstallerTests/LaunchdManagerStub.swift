import Foundation
import LaunchdManager

class LaunchdManagerStub: LaunchdManager {

    var onLoadPlist: ((LaunchdPlist, String) -> ())?
    func loadPlistToLaunchctl(plist: LaunchdPlist, plistPath: String) throws {
        onLoadPlist?(plist, plistPath)
    }
    
    var onUnloadPlist: ((LaunchdPlist, String) -> ())?
    func unloadPlistFromLaunchctl(plist: LaunchdPlist, plistPath: String) throws {
        onUnloadPlist?(plist, plistPath)
    }
    
}
