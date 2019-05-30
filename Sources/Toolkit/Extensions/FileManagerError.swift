import Foundation

public enum FileManagerError: Error, CustomStringConvertible {
    case unableToObtainFileSize(path: String)
    case unableToObtainModificationDate(path: String)
    
    public var description: String {
        switch self {
        case let .unableToObtainFileSize(path):
            return "Unable to obtain file size at path \(path)"
        case let .unableToObtainModificationDate(path):
            return "Unable to obtain modification date at path \(path)"
        }
    }
}
