import Foundation
import XcodeProj
import PathKit

final class ProjUpdateModel {
    let proj: PBXProj
    let sourceRoot: Path
    
    init(proj: PBXProj, sourceRoot: Path) {
        self.proj = proj
        self.sourceRoot = sourceRoot
    }
    
    var name: String {
        return "pbxproj-\(proj.objectVersion)-\(proj.archiveVersion)"
    }
}
