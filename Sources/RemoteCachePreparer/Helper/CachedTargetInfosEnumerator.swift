import Foundation
import XcodeProjectChecksumCalculator
import BuildProductCacheStorage
import Checksum
import Toolkit

public final class CachedTargetInfosEnumerator {
    
    public init() {}
    
    public func enumerate(
        targetInfos: [TargetInfo<BaseChecksum>],
        cacheKeyBuilder: BuildProductCacheKeyBuilder,
        cacheStorage: BuildProductCacheStorage,
        required: Bool = true,
        each: @escaping
        (CachedTargetInfo, @escaping () -> ()) -> ())
        throws
    {
        try targetInfos.asyncConcurrentEnumerate { (targetInfo, completion, stop) in
            let frameworkCacheKey = cacheKeyBuilder.createProductCacheKey(from: targetInfo)
            let dSYMCacheKey = cacheKeyBuilder.createDSYMCacheKey(from: targetInfo)
            cacheStorage.cached(for: frameworkCacheKey) { frameworkResult in
                do {
                    guard let frameworkCacheValue = try self.processCacheResult(
                        frameworkResult,
                        targetInfo: targetInfo,
                        required: required
                    ) else {
                        completion()
                        return
                    }
                    cacheStorage.cached(for: dSYMCacheKey) { dSYMResult in
                        do {
                            guard let dSYMCacheValue = try self.processCacheResult(
                                dSYMResult,
                                targetInfo: targetInfo,
                                required: required
                            ) else {
                                completion()
                                return
                            }
                            let cachedTargetInfo = CachedTargetInfo(
                                targetInfo: targetInfo,
                                frameworkCacheValue: frameworkCacheValue,
                                dSYMCacheValue: dSYMCacheValue
                            )
                            each(cachedTargetInfo) {
                                completion()
                            }
                        } catch {
                            stop(error)
                        }
                    }
                } catch {
                    stop(error)
                }
            }
        }
    }
    
    private func processCacheResult(
        _ result: BuildProductCacheResult<BaseChecksum>,
        targetInfo: TargetInfo<BaseChecksum>,
        required: Bool)
        throws -> BuildProductCacheValue<BaseChecksum>?
    {
        switch result {
        case let .result(value):
            return value
        case .notExist:
            if required {
                throw RemoteCachePreparerError.unableToObtainCache(
                    target: targetInfo.targetName,
                    type: targetInfo.productType.shortName,
                    checksumValue: targetInfo.checksum.stringValue
                )
            } else {
                return nil
            }
        }
    }
    
}
