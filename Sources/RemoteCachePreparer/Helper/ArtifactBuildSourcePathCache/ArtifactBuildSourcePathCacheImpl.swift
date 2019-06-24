import Foundation
import XcodeProjectChecksumCalculator
import Checksum
import Toolkit

public final class ArtifactBuildSourcePathCacheImpl: ArtifactBuildSourcePathCache {
    
    private let storage = BaseKeyValueStorage<ArtifactBuildSourcePathCacheKey, String>()
    
    public static let shared: ArtifactBuildSourcePathCacheImpl = {
        return ArtifactBuildSourcePathCacheImpl()
    }()
    
    private init() {}
    
    public func buildSourcePath(
        for targetInfo: TargetInfo<BaseChecksum>,
        sourcePath: String) -> String?
    {
        let key = ArtifactBuildSourcePathCacheKey(
            targetInfo: targetInfo,
            sourcePath: sourcePath
        )
        return storage.obtain(for: key)
    }
    
    public func save(
        buildSourcePath: String,
        for targetInfo: TargetInfo<BaseChecksum>,
        sourcePath: String)
    {
        let key = ArtifactBuildSourcePathCacheKey(
            targetInfo: targetInfo,
            sourcePath: sourcePath
        )
        return storage.addValue(
            buildSourcePath,
            for: key
        )
    }
    
}
