import Foundation

public enum ProjectChecksumCalculatorError: Error, CustomStringConvertible {
    case unableEncodeDataFromString(string: String)
    case emptyFullFilePath(name: String?, path: String?)
    case emptyRootGroup
    case emptyChecksum
    case unableObtainSourceRoot(projectPath: String)
    
    public var description: String {
        switch self {
        case let .unableEncodeDataFromString(string):
            return "Unable to encode data from string \(string)"
        case let .emptyFullFilePath(name, path):
            return "Unable to obtain full file path for \(name ?? "(nil)"): \(path ?? "(nil)")"
        case .emptyRootGroup:
            return "Unable to obtain root group"
        case .emptyChecksum:
            return "Unable calculate checksum"
        case let .unableObtainSourceRoot(projectPath):
            return "Unable to obtain source root for project path \(projectPath)"
        }
    }
}
