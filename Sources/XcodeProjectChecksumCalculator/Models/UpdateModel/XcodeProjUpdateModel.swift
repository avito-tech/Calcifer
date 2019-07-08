import Foundation
import XcodeProj
import PathKit
import Checksum
import Toolkit

final class XcodeProjUpdateModel {
    let xcodeProj: XcodeProj
    let sourceRoot: Path
    let projectPath: String
    
    init(xcodeProj: XcodeProj, projectPath: String, sourceRoot: Path) {
        self.xcodeProj = xcodeProj
        self.projectPath = projectPath
        self.sourceRoot = sourceRoot
    }
    
    var name: String {
        return projectPath
    }
}
