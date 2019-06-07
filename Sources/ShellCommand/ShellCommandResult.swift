import Foundation

public final class ShellCommandResult {
    
    public let terminationStatus: Int32
    public let output: String?
    public let error: String?
    
    public init(terminationStatus: Int32, output: String? = nil, error: String? = nil) {
        self.terminationStatus = terminationStatus
        self.output = output
        self.error = error
    }
}
