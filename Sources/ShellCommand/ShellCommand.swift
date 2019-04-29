import Foundation

public struct ShellCommand: CustomStringConvertible {
    
    public let launchPath: String
    public let arguments: [String]
    public let environment: [String: String]
    
    public var description: String {
        return "\(launchPath) \(arguments.joined(separator: " "))"
    }
    
    public init(
        launchPath: String,
        arguments: [String],
        environment: [String: String])
    {
        self.launchPath = launchPath
        self.arguments = arguments
        self.environment = environment
    }
}
