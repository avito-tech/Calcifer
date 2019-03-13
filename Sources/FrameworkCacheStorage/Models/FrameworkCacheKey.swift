import Foundation
import Checksum

public struct FrameworkCacheKey<ChecksumType: Checksum> {
    let frameworkName: String
    let checksum: ChecksumType
    
    public init(frameworkName: String, checksum: ChecksumType) {
        self.frameworkName = frameworkName
        self.checksum = checksum
    }
}