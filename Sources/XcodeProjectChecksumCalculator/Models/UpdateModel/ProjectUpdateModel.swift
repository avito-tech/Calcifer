import Foundation
import XcodeProj
import PathKit
import Checksum
import Toolkit

final class ProjectUpdateModel<ChecksumType: Checksum> {
    let project: PBXProject
    let sourceRoot: Path
    let cache: ThreadSafeDictionary<String, TargetChecksumHolder<ChecksumType>>
    let lock: NSLock
    let updateIdentifier: String
    
    init(
        project: PBXProject,
        sourceRoot: Path,
        cache: ThreadSafeDictionary<String,TargetChecksumHolder<ChecksumType>>,
        lock: NSLock,
        updateIdentifier: String)
    {
        self.project = project
        self.sourceRoot = sourceRoot
        self.cache = cache
        self.lock = lock
        self.updateIdentifier = updateIdentifier
    }
    
    var name: String {
        return project.name
    }
}
