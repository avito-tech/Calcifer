import Foundation

public struct CommandRunCodeMessage: Codable {
    let code: Int32
    
    init(code: Int32) {
        self.code = code
    }
}
