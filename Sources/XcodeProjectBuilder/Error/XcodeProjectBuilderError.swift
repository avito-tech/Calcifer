import Foundation

public enum XcodeProjectBuilderError: Error, CustomStringConvertible {
    case failedExecuteXcodebuild(status: Int32, command: String)
    
    public var description: String {
        switch self {
        case let .failedExecuteXcodebuild(status, command):
            return "Failed execute xcodebuild with status \(status)! Command: \(command)"
        }
    }
}
