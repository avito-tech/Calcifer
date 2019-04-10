import Foundation
import XcodeProjectChecksumCalculator
import BuildProductCacheStorage
import BuildArtifacts
import Checksum

final class ArtifactIntegrator {
    
    private let integrator: BuildArtifactIntegrator
    private let cacheKeyBuilder: BuildProductCacheKeyBuilder
    
    public init(
        integrator: BuildArtifactIntegrator,
        cacheKeyBuilder: BuildProductCacheKeyBuilder)
    {
        self.integrator = integrator
        self.cacheKeyBuilder = cacheKeyBuilder
    }
    
    @discardableResult
    public func integrateArtifacts(
        checksumProducer: BaseURLChecksumProducer,
        cacheStorage: DefaultMixedFrameworkCacheStorage,
        targetInfos: [TargetInfo<BaseChecksum>],
        to path: String) throws -> [TargetBuildArtifact<BaseChecksum>]
    {
        let artifacts: [TargetBuildArtifact<BaseChecksum>] = try targetInfos.map { targetInfo in
            
            let frameworkCacheKey = cacheKeyBuilder.createFrameworkCacheKey(from: targetInfo)
            guard let frameworkCacheValue = try cacheStorage.cached(for: frameworkCacheKey) else {
                throw RemoteCachePreparerError.unableToObtainCache(
                    target: targetInfo.targetName,
                    type: targetInfo.productType.rawValue,
                    checksumValue: targetInfo.checksum.stringValue
                )
            }
            
            let dSYMCacheKey = cacheKeyBuilder.createDSYMCacheKey(from: targetInfo)
            guard let dSYMCacheValue = try cacheStorage.cached(for: dSYMCacheKey) else {
                throw RemoteCachePreparerError.unableToObtainCache(
                    target: targetInfo.targetName,
                    type: targetInfo.productType.rawValue,
                    checksumValue: targetInfo.checksum.stringValue
                )
            }
            
            let artifact = TargetBuildArtifact(
                targetInfo: targetInfo,
                productPath: frameworkCacheValue.path,
                dsymPath: dSYMCacheValue.path
            )
            return artifact
        }
        let destionations = try integrator.integrate(artifacts: artifacts, to: path)
        return destionations
    }
}
