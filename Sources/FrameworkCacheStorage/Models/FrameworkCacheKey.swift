import Foundation
import Checksum

public struct FrameworkCacheKey<ChecksumType: Checksum>: Equatable {
    let frameworkName: String
    let checksum: ChecksumType
    
    public init(frameworkName: String, checksum: ChecksumType) {
        self.frameworkName = frameworkName
        self.checksum = checksum
    }
}
