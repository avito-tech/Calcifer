import Foundation

public enum FrameworkCacheStorageError: Error, CustomStringConvertible {
    case networkError(error: Error)
    case unableToDownloadCache(key: String)
    
    public var description: String {
        switch self {
        case let .networkError(error):
            return "Network error \(error)"
        case let .unableToDownloadCache(key):
            return "Unable to download cached item for \(key)"
        }
    }
}
