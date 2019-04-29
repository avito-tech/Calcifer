import Foundation
import XcodeProjectChecksumCalculator
import BuildProductCacheStorage
import BuildArtifacts
import Checksum
import Toolkit

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
        
        let artifacts = ThreadSafeDictionary
        <
            TargetInfo<BaseChecksum>,
            TargetBuildArtifact<BaseChecksum>
        >()
        
        let dispatchGroup = DispatchGroup()
        let array = NSArray(array: targetInfos)
        array.enumerateObjects(options: .concurrent) { obj, key, stop in
            dispatchGroup.enter()
            guard let targetInfo = obj as? TargetInfo<BaseChecksum> else {
                return
            }
            
            let frameworkCacheKey = cacheKeyBuilder.createFrameworkCacheKey(from: targetInfo)
            let dSYMCacheKey = cacheKeyBuilder.createDSYMCacheKey(from: targetInfo)
            
            cacheStorage.cached(for: frameworkCacheKey) { frameworkResult in
                let frameworkCacheValue = self.processCacheResult(frameworkResult, targetInfo: targetInfo)
                cacheStorage.cached(for: dSYMCacheKey) { dSYMResult in
                    let dSYMCacheValue = self.processCacheResult(dSYMResult, targetInfo: targetInfo)
                    let artifact = TargetBuildArtifact(
                        targetInfo: targetInfo,
                        productPath: frameworkCacheValue.path,
                        dsymPath: dSYMCacheValue.path
                    )
                    artifacts.write(artifact, for: targetInfo)
                    dispatchGroup.leave()
                }
            }
        }
        dispatchGroup.wait()

        let destionations = try integrator.integrate(artifacts: artifacts.values, to: path)
        return destionations
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
            fatalError()
        }
    }
}
