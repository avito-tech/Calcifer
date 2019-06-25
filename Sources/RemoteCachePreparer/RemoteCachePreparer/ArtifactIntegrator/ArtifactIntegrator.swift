import Foundation
import XcodeProjectChecksumCalculator
import BuildProductCacheStorage
import BuildArtifacts
import Checksum
import Toolkit

public final class ArtifactIntegrator {
    
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
        cacheStorage: BuildProductCacheStorage,
        targetInfos: [TargetInfo<BaseChecksum>],
        to path: String) throws -> [TargetBuildArtifact<BaseChecksum>]
    {
        
        let artifacts = ThreadSafeDictionary
        <
            TargetInfo<BaseChecksum>,
            TargetBuildArtifact<BaseChecksum>
        >()
        
        let enumerator = CachedTargetInfosEnumerator()
        try enumerator.enumerate(
            targetInfos: targetInfos,
            cacheKeyBuilder: cacheKeyBuilder,
            cacheStorage: cacheStorage) { cachedTargetInfo, completion  in
                let artifact = TargetBuildArtifact(
                    targetInfo: cachedTargetInfo.targetInfo,
                    productPath: cachedTargetInfo.frameworkCacheValue.path,
                    dsymPath: cachedTargetInfo.dSYMCacheValue.path
                )
                artifacts.write(artifact, for: cachedTargetInfo.targetInfo)
                completion()
        }
        
        let destionations = try integrator.integrate(artifacts: artifacts.values, to: path)
        return destionations
    }
    
}
