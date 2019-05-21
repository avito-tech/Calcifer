import Foundation

public enum BuildProductCacheStorageError: Error, CustomStringConvertible {
    case unableToFindBuildProduct(path: String)
    case unableToUnzipFile(path: String)
    
    public var description: String {
        switch self {
        case let .unableToFindBuildProduct(path):
            return "Unable to find build product at path \(path)"
        case let .unableToUnzipFile(path):
            return "Unable to unzip file at path \(path)"
        }
    }
}
