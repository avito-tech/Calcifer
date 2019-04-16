import Foundation

public enum BuildProductCacheStorageError: Error, CustomStringConvertible {
    case networkError(error: Error?)
    case unableToDownloadCache(key: String)
    case unableToFindBuildProduct(path: String)
    
    public var description: String {
        switch self {
        case let .networkError(error):
            if let error = error {
                return "Network error \(error)"
            }
            return "Network error"
        case let .unableToDownloadCache(key):
            return "Unable to download cached item for \(key)"
        case .unableToFindBuildProduct:
            return "Unable to find build product"
        }
    }
}
