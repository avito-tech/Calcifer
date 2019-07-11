import Foundation
import BuildArtifacts

final class TargetBuildArtifactMetaInfoManagerStub: TargetBuildArtifactMetaInfoManager {
    
    init() {}
    
    func write(metaInfo: TargetBuildArtifactMetaInfo, artifactURL: URL) throws {
        
    }
    
    func readMetaInfo(artifactURL: URL) throws -> TargetBuildArtifactMetaInfo? {
        return nil
    }
    
    func metaInfoFileName() -> String {
        return "metainfo.json"
    }
    
    
}
