import Foundation

public enum FileManagerError: Error, CustomStringConvertible {
    case unableToObtainFileSize(path: String)
    case unableToObtainModificationDate(path: String)
    case unableToWriteFile(path: String, content: [String: Any])
    
    public var description: String {
        switch self {
        case let .unableToObtainFileSize(path):
            return "Unable to obtain file size at path \(path)"
        case let .unableToObtainModificationDate(path):
            return "Unable to obtain modification date at path \(path)"
        case let .unableToWriteFile(path, content):
            return "Unable to write file at path \(path) with content \(content)"
        }
    }
}
