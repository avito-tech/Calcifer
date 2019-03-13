import Foundation
import Checksum

public struct CacheKey<ChecksumType: Checksum> {
    let name: String
    let checksum: ChecksumType
    
    public init(name: String, checksum: ChecksumType) {
        self.name = name
        self.checksum = checksum
    }
}
