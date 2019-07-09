import Foundation
import XcodeProj
import PathKit
import Checksum
import Toolkit

class ProjectChecksumHolder<ChecksumType: Checksum>: BaseChecksumHolder<ChecksumType> {
    
    override var children: [String: BaseChecksumHolder<ChecksumType>] {
        return targets
    }
    
    var targets = [String: TargetChecksumHolder<ChecksumType>]()
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
        let cache = updateModel.cache
        let targetUpdateModelsDictionary = updateModel.project.targets
            .map { target in
                TargetUpdateModel<ChecksumType>(
                    target: target,
                    sourceRoot: updateModel.sourceRoot,
                    cache: cache
                )
            }.toDictionary { $0.name }
        let shouldInvalidate = try targetUpdateModelsDictionary.update(
            childrenDictionary: &targets,
            update: { targetChecksumHolder, targetUpdateModel in
                try targetChecksumHolder.reflectUpdate(updateModel: targetUpdateModel)
            }, buildValue: { targetUpdateModel in
                cache.createIfNotExist(targetUpdateModel.name) { _ in
                    TargetChecksumHolder(
                        updateModel: targetUpdateModel,
                        parent: self,
                        fullPathProvider: fullPathProvider,
                        checksumProducer: checksumProducer
                    )
                }
            }
        )
        
        if shouldInvalidate {
            invalidate()
        }        
    }

}
