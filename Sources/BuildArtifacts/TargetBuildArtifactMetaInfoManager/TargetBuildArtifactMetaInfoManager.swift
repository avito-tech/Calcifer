import Foundation
import Checksum

public protocol TargetBuildArtifactMetaInfoManager {
    
    func write(
        metaInfo: TargetBuildArtifactMetaInfo,
        artifactURL: URL) throws
    
    func readMetaInfo(artifactURL: URL) throws -> TargetBuildArtifactMetaInfo?
    
    func metaInfoFileName() -> String
}
