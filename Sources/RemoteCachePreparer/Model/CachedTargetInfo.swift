import Foundation
import XcodeProjectChecksumCalculator
import BuildProductCacheStorage
import Checksum
import Toolkit

public final class CachedTargetInfo {
    public let targetInfo: TargetInfo<BaseChecksum>
    public let frameworkCacheValue: BuildProductCacheValue<BaseChecksum>
    public let dSYMCacheValue: BuildProductCacheValue<BaseChecksum>
    
    public init(
        targetInfo: TargetInfo<BaseChecksum>,
        frameworkCacheValue: BuildProductCacheValue<BaseChecksum>,
        dSYMCacheValue: BuildProductCacheValue<BaseChecksum>)
    {
        self.targetInfo = targetInfo
        self.frameworkCacheValue = frameworkCacheValue
        self.dSYMCacheValue = dSYMCacheValue
    }
}
