import Foundation
import Checksum

public protocol FrameworkCacheStorage {
    
    associatedtype ChecksumType: Checksum
    
    func cached(for cacheKey: FrameworkCacheKey<ChecksumType>) throws -> FrameworkCacheValue<ChecksumType>?
    
    func add(cacheKey: FrameworkCacheKey<ChecksumType>, at path: String) throws
    
}
