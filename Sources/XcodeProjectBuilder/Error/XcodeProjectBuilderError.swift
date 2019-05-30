import Foundation

public enum XcodeProjectBuilderError: Error, CustomStringConvertible {
    case failedExecuteXcodebuild(status: Int32, command: String)
    case failedParseCommandLineToolVersion(string: String?)
    
    public var description: String {
        switch self {
        case let .failedExecuteXcodebuild(status, command):
            return "Failed execute xcodebuild with status \(status)! Command: \(command)"
        case let .failedParseCommandLineToolVersion(string):
            return "Failed parse command line tool version from string: \(string ?? "-")"
        }
    }
}
