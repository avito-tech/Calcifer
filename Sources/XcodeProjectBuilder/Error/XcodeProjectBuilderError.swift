import Foundation

public enum XcodeProjectBuilderError: Error, CustomStringConvertible {
    case failedExecuteXcodebuild(status: Int32, command: String, error: String?)
    case failedCheckCommandLineToolVersion(status: Int32, command: String, error: String?)
    case failedParseCommandLineToolVersion(string: String?)
    case failedCreateBuildLogFile(path: String)
    
    public var description: String {
        switch self {
        case let .failedExecuteXcodebuild(status, command, error):
            return "Failed execute xcodebuild with status \(status) \(error ?? "")! Command: \(command)."
        case let .failedCheckCommandLineToolVersion(status, command, error):
            return "Failed check command line tool version with status \(status). Command: \(command). Error: \(error ?? "-")"
        case let .failedParseCommandLineToolVersion(string):
            return "Failed parse command line tool version from string: \(string ?? "-")"
        case let .failedCreateBuildLogFile(path):
            return "Failed create build log file at path \(path)"
        }
    }
}
