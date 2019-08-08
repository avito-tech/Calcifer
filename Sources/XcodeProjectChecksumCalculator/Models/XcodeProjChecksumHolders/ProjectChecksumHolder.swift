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
class ProjectChecksumHolder<ChecksumType: Checksum>: BaseChecksumHolder<ChecksumType> {
    
    override var children: ThreadSafeDictionary<String, BaseChecksumHolder<ChecksumType>> {
        return targets.cast { $0 }
    }
    
    var targets = ThreadSafeDictionary<String, TargetChecksumHolder<ChecksumType>>()
    private let fullPathProvider: FileElementFullPathProvider
    private let checksumProducer: URLChecksumProducer<ChecksumType>
    
    init(
        name: String,
        parent: ProjChecksumHolder<ChecksumType>,
        fullPathProvider: FileElementFullPathProvider,
        checksumProducer: URLChecksumProducer<ChecksumType>)
    {
        self.fullPathProvider = fullPathProvider
        self.checksumProducer = checksumProducer
        super.init(name: name, parent: parent)
    }
    
    override func calculateChecksum() throws -> ChecksumType {
        return try targets.values.sorted().map {
            try $0.obtainChecksum()
        }.aggregate()
    }
    
    func reflectUpdate(updateModel: ProjectUpdateModel<ChecksumType>) throws {
        let targetCache = updateModel.targetCache
        let targetUpdateModelsDictionary = updateModel.project.targets
            .map { target in
                TargetUpdateModel<ChecksumType>(
                    target: target,
                    sourceRoot: updateModel.sourceRoot,
                    targetCache: targetCache,
                    fileCache: updateModel.fileCache
                )
            }.toDictionary { $0.name }
        let shouldInvalidate = try targetUpdateModelsDictionary.update(
            childrenDictionary: targets,
            update: { targetChecksumHolder, targetUpdateModel in
                targetChecksumHolder.parents.write(self, for: name)
                try targetChecksumHolder.reflectUpdate(updateModel: targetUpdateModel)
            },
            onRemove: { _ in

            },
            buildValue: { targetUpdateModel in
                targetCache.createIfNotExist(targetUpdateModel.name) { _ in
                    TargetChecksumHolder(
                        updateModel: targetUpdateModel,
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
