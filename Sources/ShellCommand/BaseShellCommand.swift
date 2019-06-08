import Foundation

public struct BaseShellCommand: ShellCommand {
    
    public let launchPath: String
    public let arguments: [String]
    public let environment: [String: String]
    
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
