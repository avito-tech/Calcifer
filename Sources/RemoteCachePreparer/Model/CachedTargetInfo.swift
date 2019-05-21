import Foundation
import XcodeProjectChecksumCalculator
import BuildProductCacheStorage
import Checksum
import Toolkit

final class CachedTargetInfo {
    let targetInfo: TargetInfo<BaseChecksum>
    let frameworkCacheValue: BuildProductCacheValue<BaseChecksum>
    let dSYMCacheValue: BuildProductCacheValue<BaseChecksum>
    
    init(
        targetInfo: TargetInfo<BaseChecksum>,
        frameworkCacheValue: BuildProductCacheValue<BaseChecksum>,
        dSYMCacheValue: BuildProductCacheValue<BaseChecksum>)
    {
        self.targetInfo = targetInfo
        self.frameworkCacheValue = frameworkCacheValue
        self.dSYMCacheValue = dSYMCacheValue
    }
}
