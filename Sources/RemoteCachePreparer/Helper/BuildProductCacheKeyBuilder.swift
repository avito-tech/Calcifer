import Foundation
import XcodeProjectChecksumCalculator
import BuildProductCacheStorage
import Checksum

final class BuildProductCacheKeyBuilder {
    
    public init() {}
    
    public func createFrameworkCacheKey(
        from targetInfo: TargetInfo<BaseChecksum>)
        -> BuildProductCacheKey<BaseChecksum>
    {
        return BuildProductCacheKey<BaseChecksum>(
            productName: targetInfo.productName,
            productType: .framework,
            checksum: targetInfo.checksum
        )
    }
    
    public func createDSYMCacheKey(
        from targetInfo: TargetInfo<BaseChecksum>)
        -> BuildProductCacheKey<BaseChecksum>
    {
        return BuildProductCacheKey<BaseChecksum>(
            productName: targetInfo.productName,
            productType: .dSYM,
            checksum: targetInfo.checksum
        )
    }
    
}
