import Foundation
import XcodeProj
import PathKit
import Checksum
import Toolkit

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Xcode models structure:                                                                                                //
// XcodeProj - root, represent *.xcodeproj file. It contains pbxproj file represented by Proj (Look below) and xcschemes. //
// Proj - represent project.pbxproj file. It contains all references to objects - projects, files, groups, targets etc.   //
// Project - represent build project. It contains build settings and targets.                                             //
// Target - represent build target. It contains build phases. For example source build phase.                             //
// File - represent source file. Can be obtained from source build phase.                                                 //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
final class XcodeProjUpdateModel {
    let xcodeProj: XcodeProj
    let sourceRoot: Path
    let configurationName: String
    let projectPath: String
    
    init(xcodeProj: XcodeProj, projectPath: String, sourceRoot: Path, configurationName: String) {
        self.xcodeProj = xcodeProj
        self.projectPath = projectPath
        self.sourceRoot = sourceRoot
        self.configurationName = configurationName
    }
    
    var name: String {
        return projectPath
    }
}
