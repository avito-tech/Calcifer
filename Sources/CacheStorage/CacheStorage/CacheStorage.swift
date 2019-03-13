import Foundation
import Checksum

public protocol CacheStorage {
    
    associatedtype ChecksumType: Checksum
    
    func cache(for cacheKey: CacheKey<ChecksumType>) throws -> CacheValue<ChecksumType>?
    
    @discardableResult
    func add(cacheKey: CacheKey<ChecksumType>, at path: String) throws -> CacheValue<ChecksumType>
    
    func purge() throws
    
}
