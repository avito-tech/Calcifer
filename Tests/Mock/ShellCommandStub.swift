import Foundation
import ShellCommand

public struct ShellCommandStub {
    public let launchPath: String
    public let arguments: [String]
    public let output: String?
    public let error: String?
    
    public init(
        launchPath: String,
        arguments: [String] = [String](),
        output: String? = nil,
        error: String? = nil)
    {
        self.launchPath = launchPath
        self.arguments = arguments
        self.output = output
        self.error = error
    }
    
    public init(_ command: ShellCommand, output: String? = nil, error: String? = nil) {
        self.init(
            launchPath: command.launchPath,
            arguments: command.arguments,
            output: output,
            error: error
        )
    }
}
