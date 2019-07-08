import Foundation
import XcodeProj
import PathKit
import Checksum
import Toolkit

final class ProjUpdateModel<ChecksumType: Checksum> {
    let proj: PBXProj
    let sourceRoot: Path
    let cache: ThreadSafeDictionary<String, TargetChecksumHolder<ChecksumType>>
    
    init(
        proj: PBXProj,
        sourceRoot: Path,
        cache: ThreadSafeDictionary<String, TargetChecksumHolder<ChecksumType>>)
    {
        self.proj = proj
        self.sourceRoot = sourceRoot
        self.cache = cache
    }
    
    var name: String {
        return "pbxproj-\(proj.objectVersion)-\(proj.archiveVersion)"
    }
}
