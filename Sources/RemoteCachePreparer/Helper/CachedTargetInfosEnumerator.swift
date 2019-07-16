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
        each: @escaping
        (CachedTargetInfo, @escaping () -> ()) -> ())
        throws
    {
        try targetInfos.asyncConcurrentEnumerate { (targetInfo, completion, stop) in
            let frameworkCacheKey = cacheKeyBuilder.createFrameworkCacheKey(from: targetInfo)
            let dSYMCacheKey = cacheKeyBuilder.createDSYMCacheKey(from: targetInfo)
            var processError: Error?
            cacheStorage.cached(for: frameworkCacheKey) { frameworkResult in
                do {
                    let frameworkCacheValue = try self.processCacheResult(frameworkResult, targetInfo: targetInfo)
                    cacheStorage.cached(for: dSYMCacheKey) { dSYMResult in
                        do {
                            let dSYMCacheValue = try self.processCacheResult(dSYMResult, targetInfo: targetInfo)
                            let cachedTargetInfo = CachedTargetInfo(
                                targetInfo: targetInfo,
                                frameworkCacheValue: frameworkCacheValue,
                                dSYMCacheValue: dSYMCacheValue
                            )
                            each(cachedTargetInfo) {
                                completion()
                            }
                        } catch {
                            processError = error
                            stop()
                        }
                    }
                } catch {
                    processError = error
                    stop()
                }
            }
            
            if let error = processError {
                throw error
            }
        }
    }
    
    private func processCacheResult(
        _ result: BuildProductCacheResult<BaseChecksum>,
        targetInfo: TargetInfo<BaseChecksum>)
        throws -> BuildProductCacheValue<BaseChecksum>
    {
        switch result {
        case let .result(value):
            return value
        case .notExist:
            throw RemoteCachePreparerError.unableToObtainCache(
                target: targetInfo.targetName,
                type: targetInfo.productType.rawValue,
                checksumValue: targetInfo.checksum.stringValue
            )
        }
    }
    
}
