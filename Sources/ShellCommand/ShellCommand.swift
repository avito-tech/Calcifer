import Foundation

public struct ShellCommand: CustomStringConvertible {
    
    let launchPath: String
    let arguments: [String]
    let environment: [String: String]
    
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
