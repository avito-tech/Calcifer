import Foundation
import ShellCommand

struct LaunchctlShellCommand: ShellCommand {
    
    enum CommandType: String {
        case load
        case unload
    }
    private let type: CommandType
    private let plistPath: String
    
    let launchPath = "/bin/launchctl"
    var arguments: [String] {
        return [
            type.rawValue,
            plistPath
        ]
    }
    var environment = [String: String]()
    
    init(plistPath: String, type: CommandType) {
        self.plistPath = plistPath
        self.type = type
    }
    
}
