import Foundation
import XcodeProj
import PathKit

final class ProjectUpdateModel {
    let project: PBXProject
    let sourceRoot: Path
    
    init(project: PBXProject, sourceRoot: Path) {
        self.project = project
        self.sourceRoot = sourceRoot
    }
    
    var name: String {
        return project.name
    }
}
