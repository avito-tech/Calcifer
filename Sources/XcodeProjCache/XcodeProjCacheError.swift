import Foundation

public enum XcodeProjCacheError: Error, CustomStringConvertible {
    case emptyModificationDate(path: String)
    
    public var description: String {
        switch self {
        case let .emptyModificationDate(path):
            return "Can't obtain modification date for \(path)"
        }
    }
}
