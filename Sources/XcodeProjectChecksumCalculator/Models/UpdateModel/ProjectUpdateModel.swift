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
final class ProjectUpdateModel<ChecksumType: Checksum> {
    let project: PBXProject
    let sourceRoot: Path
    let targetCache: ThreadSafeDictionary<String, TargetChecksumHolder<ChecksumType>>
    let fileCache: ThreadSafeDictionary<String, FileChecksumHolder<ChecksumType>>
    
    init(
        project: PBXProject,
        sourceRoot: Path,
        targetCache: ThreadSafeDictionary<String, TargetChecksumHolder<ChecksumType>>,
        fileCache: ThreadSafeDictionary<String, FileChecksumHolder<ChecksumType>>)
    {
        self.project = project
        self.sourceRoot = sourceRoot
        self.targetCache = targetCache
        self.fileCache = fileCache
    }
    
    var name: String {
        return project.name
    }
}
