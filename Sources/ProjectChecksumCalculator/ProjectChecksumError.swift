import Foundation

public enum ProjectChecksumError: Error, CustomStringConvertible {
    case unableEncodeDataFromString(string: String)
    case emptyFullFilePath(name: String?, path: String?)
    case emptyRootGroup
    case emptyChecksum
    case fileDoesntExist(path: String)
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
        case let .fileDoesntExist(path):
            return "File doesn't exist at path \(path)"
        case let .unableObtainSourceRoot(projectPath):
            return "Unable to obtain source root for project path \(projectPath)"
        }
    }
}
