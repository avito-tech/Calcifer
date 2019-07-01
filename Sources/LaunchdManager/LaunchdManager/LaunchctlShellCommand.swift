import Foundation
import ShellCommand

struct LaunchctlShellCommand: ShellCommand {
    
    enum CommandType: String {
        case load = "bootstrap"
        case unload = "bootout"
        case enable
        case disable
    }
    private let type: CommandType
    private let domain: LaunchdDomain
    private let plist: LaunchdPlist
    private let plistPath: String
    
    let launchPath = "/bin/launchctl"
    var arguments: [String] {
        switch type {
        case .load:
            return [
                type.rawValue,
                domain.stringValue,
                plistPath
            ]
        case .unload:
            return [
                type.rawValue,
                domain.stringValue,
                plistPath
            ]
        case .enable:
            return [
                type.rawValue,
                "\(domain.stringValue)/\(plist.label)"
            ]
        case .disable:
            return [
                type.rawValue,
                "\(domain.stringValue)/\(plist.label)"
            ]
        }

    }
    var environment = [String: String]()
    
    init(plist: LaunchdPlist, plistPath: String, type: CommandType, domain: LaunchdDomain) {
        self.plist = plist
        self.plistPath = plistPath
        self.type = type
        self.domain = domain
    }
    
}
