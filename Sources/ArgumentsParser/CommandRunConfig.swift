import Foundation

public struct CommandRunConfig: Codable, CustomDebugStringConvertible {
    
    public let identifier: String
    public let arguments: [String]
    
    public init(identifier: String, arguments: [String]) {
        self.identifier = identifier
        self.arguments = arguments
    }
    
    public var debugDescription: String {
        return "CommandRunConfig identifier: \(identifier) arguments: \(arguments)"
    }
}
