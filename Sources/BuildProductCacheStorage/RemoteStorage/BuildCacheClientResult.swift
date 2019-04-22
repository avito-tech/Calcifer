import Foundation

public enum BuildCacheClientResult<T> {
    case success(T)
    case failure(Error?)
}
