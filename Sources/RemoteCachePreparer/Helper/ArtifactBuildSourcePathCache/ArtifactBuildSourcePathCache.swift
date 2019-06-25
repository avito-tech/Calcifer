import Foundation
import XcodeProjectChecksumCalculator
import Checksum

public protocol ArtifactBuildSourcePathCache {
    
    func buildSourcePath(
        for targetInfo: TargetInfo<BaseChecksum>,
        sourcePath: String
    ) -> String?
    
    func save(
        buildSourcePath: String,
        for targetInfo: TargetInfo<BaseChecksum>,
        sourcePath: String
    )
}
