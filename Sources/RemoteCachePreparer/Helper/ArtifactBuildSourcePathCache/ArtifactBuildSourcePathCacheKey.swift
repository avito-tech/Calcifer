import Foundation
import XcodeProjectChecksumCalculator
import Checksum

struct ArtifactBuildSourcePathCacheKey: Hashable {
    let targetInfo: TargetInfo<BaseChecksum>
    let sourcePath: String
}
