import Foundation

public enum BuildProductCacheStorageError: Error, CustomStringConvertible {
    case unableToFindBuildProduct(path: String)
    
    public var description: String {
        switch self {
        case .unableToFindBuildProduct:
            return "Unable to find build product"
        }
    }
}
