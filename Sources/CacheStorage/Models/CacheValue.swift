import Foundation
import Checksum

public struct CacheValue<ChecksumType: Checksum> {
    
    public let entry: CacheEntry<ChecksumType>
    public let path: String
    
    public init(entry:  CacheEntry<ChecksumType>, path: String) {
        self.entry = entry
        self.path = path
    }
}
