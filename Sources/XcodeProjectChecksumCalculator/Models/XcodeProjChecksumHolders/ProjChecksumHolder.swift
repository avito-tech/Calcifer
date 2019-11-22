import Foundation
import Checksum
import XcodeProj
import PathKit
import Toolkit

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Xcode models structure:                                                                                                //
// XcodeProj - root, represent *.xcodeproj file. It contains pbxproj file represented by Proj (Look below) and xcschemes. //
// Proj - represent project.pbxproj file. It contains all references to objects - projects, files, groups, targets etc.   //
// Project - represent build project. It contains build settings and targets.                                             //
// Target - represent build target. It contains build phases. For example source build phase.                             //
// File - represent source file. Can be obtained from source build phase.                                                 //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
final class ProjChecksumHolder<ChecksumType: Checksum>: BaseChecksumHolder<ChecksumType> {
    
    override var children: ThreadSafeDictionary<String, BaseChecksumHolder<ChecksumType>> {
        return projects.cast { $0 }
    }
    
    var projects = ThreadSafeDictionary<String, ProjectChecksumHolder<ChecksumType>>()
    
    private let fullPathProvider: FileElementFullPathProvider
    private let checksumProducer: URLChecksumProducer<ChecksumType>
    
    init(
        name: String,
        parent: XcodeProjChecksumHolder<ChecksumType>,
        fullPathProvider: FileElementFullPathProvider,
        checksumProducer: URLChecksumProducer<ChecksumType>)
    {
        self.fullPathProvider = fullPathProvider
        self.checksumProducer = checksumProducer
        super.init(name: name, parent: parent)
    }
    
    override func calculateChecksum() throws -> ChecksumType {
        return try projects.values.sorted().map {
            try $0.obtainChecksum()
        }.aggregate()
    }
    
    func reflectUpdate(updateModel: ProjUpdateModel<ChecksumType>) throws {
        let projectUpdateModelsDictionary = updateModel.proj.projects
            .map { project in
                ProjectUpdateModel(
                    project: project,
                    sourceRoot: updateModel.sourceRoot,
                    configurationName: updateModel.configurationName,
                    targetCache: updateModel.targetCache,
                    fileCache: updateModel.fileCache
                )
            }.toDictionary { $0.name }
        let shouldInvalidate = try projectUpdateModelsDictionary.update(
            childrenDictionary: projects,
            update: { projectChecksumHolder, projectUpdateModel in
                projectChecksumHolder.parents.write(self, for: name)
                try projectChecksumHolder.reflectUpdate(updateModel: projectUpdateModel)
            }, onRemove: { _ in
                
            }, buildValue: { projectUpdateModel in
                updateModel.projectCache.createIfNotExist(projectUpdateModel.name) { _ in
                    ProjectChecksumHolder(
                        name: projectUpdateModel.name,
                        parent: self,
                        fullPathProvider: fullPathProvider,
                        checksumProducer: checksumProducer
                    )
                }.value
            }
        )
        if shouldInvalidate {
            invalidate()
        }
    }
}
