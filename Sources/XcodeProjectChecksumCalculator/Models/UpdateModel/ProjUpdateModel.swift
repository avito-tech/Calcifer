import Foundation
import XcodeProj
import PathKit
import Checksum
import Toolkit

final class ProjUpdateModel<ChecksumType: Checksum> {
    let proj: PBXProj
    let sourceRoot: Path
    let cache: ThreadSafeDictionary<String, TargetChecksumHolder<ChecksumType>>
    let lock: NSLock
    let updateIdentifier: String
    
    init(
        proj: PBXProj,
        sourceRoot: Path,
        cache: ThreadSafeDictionary<String, TargetChecksumHolder<ChecksumType>>,
        lock: NSLock,
        updateIdentifier: String) {
        self.proj = proj
        self.sourceRoot = sourceRoot
        self.cache = cache
        self.lock = lock
        self.updateIdentifier = updateIdentifier
    }
    
    var name: String {
        return "pbxproj-\(proj.objectVersion)-\(proj.archiveVersion)"
    }
}
