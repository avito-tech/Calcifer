import Foundation
import Checksum

public protocol FrameworkCacheStorage {
    
    associatedtype ChecksumType: Checksum
    
    func cache(for cacheKey: FrameworkCacheKey<ChecksumType>) throws -> FrameworkCacheValue<ChecksumType>?
    
    @discardableResult
    func add(cacheKey: FrameworkCacheKey<ChecksumType>, at path: String) throws -> FrameworkCacheValue<ChecksumType>
    
    func purge() throws
    
}
