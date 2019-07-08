import Foundation
import XcodeProj
import PathKit
import Checksum
import Toolkit

final class XcodeProjUpdateModel {
    let xcodeProj: XcodeProj
    let sourceRoot: Path
    let projectPath: String
    let updateIdentifier: String
    
    init(xcodeProj: XcodeProj, projectPath: String, sourceRoot: Path, updateIdentifier: String) {
        self.xcodeProj = xcodeProj
        self.projectPath = projectPath
        self.sourceRoot = sourceRoot
        self.updateIdentifier = updateIdentifier
    }
    
    var name: String {
        return projectPath
    }
}
