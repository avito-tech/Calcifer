import Foundation
import Checksum

public final class TargetBuildArtifactMetaInfoManagerImpl: TargetBuildArtifactMetaInfoManager {

    private let fileManager: FileManager
    
    public init(fileManager: FileManager) {
        self.fileManager = fileManager
    }
    
    public func write(
        metaInfo: TargetBuildArtifactMetaInfo,
        artifactURL: URL)
        throws
    {
        let metaInfoURL = artifactURL.appendingPathComponent(metaInfoFileName())
        try metaInfo.save(to: metaInfoURL.path)
    }
    
    public func readMetaInfo(artifactURL: URL) throws -> TargetBuildArtifactMetaInfo? {
        let metaInfoURL = artifactURL.appendingPathComponent(metaInfoFileName())
        guard fileManager.fileExists(atPath: metaInfoURL.path) else {
            return nil
        }
        return try TargetBuildArtifactMetaInfo.decode(from: metaInfoURL.path)
    }
    
    public func metaInfoFileName() -> String {
        return "meta.json"
    }
}
