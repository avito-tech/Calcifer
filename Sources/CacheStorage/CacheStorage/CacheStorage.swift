import Foundation
import Checksum

public protocol CacheStorage {
    
    associatedtype ChecksumType: Checksum
    
    func cache(for entry: CacheEntry<ChecksumType>) throws -> CacheValue<ChecksumType>?
    
    @discardableResult
    func add(entry: CacheEntry<ChecksumType>, at path: String) throws -> CacheValue<ChecksumType>
    
    func purge() throws
    
}
