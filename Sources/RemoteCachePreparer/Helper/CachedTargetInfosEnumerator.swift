import Foundation
import XcodeProjectChecksumCalculator
import BuildProductCacheStorage
import Checksum
import Toolkit

final class CachedTargetInfosEnumerator {
    
    func enumerate(
        targetInfos: [TargetInfo<BaseChecksum>],
        cacheKeyBuilder: BuildProductCacheKeyBuilder,
        cacheStorage: BuildProductCacheStorage,
        each: @escaping
        (CachedTargetInfo, @escaping () -> ()) -> ())
        throws
    {
        try targetInfos.asyncConcurrentEnumerated { (targetInfo, completion, _) in
            let frameworkCacheKey = cacheKeyBuilder.createFrameworkCacheKey(from: targetInfo)
            let dSYMCacheKey = cacheKeyBuilder.createDSYMCacheKey(from: targetInfo)
            
            cacheStorage.cached(for: frameworkCacheKey) { frameworkResult in
                let frameworkCacheValue = self.processCacheResult(frameworkResult, targetInfo: targetInfo)
                cacheStorage.cached(for: dSYMCacheKey) { dSYMResult in
                    let dSYMCacheValue = self.processCacheResult(dSYMResult, targetInfo: targetInfo)
                    let cachedTargetInfo = CachedTargetInfo(
                        targetInfo: targetInfo,
                        frameworkCacheValue: frameworkCacheValue,
                        dSYMCacheValue: dSYMCacheValue
                    )
                    each(cachedTargetInfo) {
                        completion()
                    }
                }
            }
        }
    }
    
    private func processCacheResult(
        _ result: BuildProductCacheResult<BaseChecksum>,
        targetInfo: TargetInfo<BaseChecksum>)
        -> BuildProductCacheValue<BaseChecksum>
    {
        switch result {
        case let .result(value):
            return value
        case .notExist:
            catchError {
                throw RemoteCachePreparerError.unableToObtainCache(
                    target: targetInfo.targetName,
                    type: targetInfo.productType.rawValue,
                    checksumValue: targetInfo.checksum.stringValue
                )
            }
            fatalError("Unable to obtain local cache")
        }
    }
    
}
