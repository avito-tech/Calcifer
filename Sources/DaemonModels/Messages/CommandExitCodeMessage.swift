import Foundation

public struct CommandExitCodeMessage: Codable {
    public let code: Int32
    
    public init(code: Int32) {
        self.code = code
    }
}
