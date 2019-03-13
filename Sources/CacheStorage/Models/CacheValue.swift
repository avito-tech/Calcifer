import Foundation
import Checksum

public struct CacheValue<ChecksumType: Checksum> {
    
    public let key: CacheKey<ChecksumType>
    public let path: String
    
    public init(key: CacheKey<ChecksumType>, path: String) {
        self.key = key
        self.path = path
    }
}
