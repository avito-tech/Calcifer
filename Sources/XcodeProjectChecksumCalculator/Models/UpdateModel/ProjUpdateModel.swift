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
final class ProjUpdateModel<ChecksumType: Checksum> {
    let proj: PBXProj
    let projectPath: String
    let sourceRoot: Path
    let cache: ThreadSafeDictionary<String, TargetChecksumHolder<ChecksumType>>
    
    init(
        proj: PBXProj,
        projectPath: String,
        sourceRoot: Path,
        cache: ThreadSafeDictionary<String, TargetChecksumHolder<ChecksumType>>)
    {
        self.proj = proj
        self.projectPath = projectPath
        self.sourceRoot = sourceRoot
        self.cache = cache
    }
    
    var name: String {
        return "pbxproj-\(projectPath)"
    }
}