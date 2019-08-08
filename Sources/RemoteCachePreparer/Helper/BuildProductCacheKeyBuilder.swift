import Foundation
import XcodeProjectChecksumCalculator
import BuildProductCacheStorage
import Checksum

public final class BuildProductCacheKeyBuilder {
    
    public init() {}
    
    public func createProductCacheKey(
        from targetInfo: TargetInfo<BaseChecksum>)
        -> BuildProductCacheKey<BaseChecksum>
    {
        return BuildProductCacheKey<BaseChecksum>(
            productName: targetInfo.productName,
            productType: .product(targetInfo.productType),
            checksum: targetInfo.checksum
        )
    }
    
    public func createDSYMCacheKey(
        from targetInfo: TargetInfo<BaseChecksum>)
        -> BuildProductCacheKey<BaseChecksum>
    {
        return BuildProductCacheKey<BaseChecksum>(
            productName: targetInfo.productName,
            productType: .dSYM(targetInfo.productType),
            checksum: targetInfo.checksum
        )
    }
    
}
