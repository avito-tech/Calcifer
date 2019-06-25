import Foundation
import LaunchdManager

class LaunchdManagerStub: LaunchdManager {    
    
    var onLoadPlist: ((LaunchdPlist, String) -> ())?
    func loadPlistToLaunchctl(plist: LaunchdPlist, plistPath: String) throws {
        onLoadPlist?(plist, plistPath)
    }
    
    var onUnloadPlist: ((LaunchdSessionType, String) -> ())?
    func unloadPlistFromLaunchctl(sessionType: LaunchdSessionType, plistPath: String) throws {
        onUnloadPlist?(sessionType, plistPath)
    }
    
}
