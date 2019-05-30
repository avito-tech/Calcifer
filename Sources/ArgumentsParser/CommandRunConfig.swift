import Foundation

public struct CommandRunConfig: Codable {
    
    public let arguments: [String]
    
    public init(arguments: [String]) {
        self.arguments = arguments
    }
}
