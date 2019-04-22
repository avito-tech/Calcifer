import Foundation
import Checksum

public struct BuildProductCacheValue<ChecksumType: Checksum> {
    
    public let key: BuildProductCacheKey<ChecksumType>
    public let path: String
    
    public init(key: BuildProductCacheKey<ChecksumType>, path: String) {
        self.key = key
        self.path = path
    }
}
