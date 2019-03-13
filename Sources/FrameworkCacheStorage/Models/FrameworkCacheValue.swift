import Foundation
import Checksum

public struct FrameworkCacheValue<ChecksumType: Checksum> {
    
    public let key: FrameworkCacheKey<ChecksumType>
    public let path: String
    
    public init(key: FrameworkCacheKey<ChecksumType>, path: String) {
        self.key = key
        self.path = path
    }
}
