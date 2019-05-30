import Foundation

public struct CommandExitCodeMessage: Codable {
    let code: Int32
    
    init(code: Int32) {
        self.code = code
    }
}
