import Foundation
import XcodeProj
import PathKit
import Checksum
import Toolkit

final class ProjectUpdateModel<ChecksumType: Checksum> {
    let project: PBXProject
    let sourceRoot: Path
    let cache: ThreadSafeDictionary<String, TargetChecksumHolder<ChecksumType>>
    
    init(
        project: PBXProject,
        sourceRoot: Path,
        cache: ThreadSafeDictionary<String,TargetChecksumHolder<ChecksumType>>)
    {
        self.project = project
        self.sourceRoot = sourceRoot
        self.cache = cache
    }
    
    var name: String {
        return project.name
    }
}
