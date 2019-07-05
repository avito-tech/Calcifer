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
    
    init(name: String, parent: ProjChecksumHolder<ChecksumType>) {
        super.init(name: name, parent: parent)
    }
    
    override public func calculateChecksum<ChecksumProducer: URLChecksumProducer>(checksumProducer: ChecksumProducer)
        throws -> ChecksumType
        where ChecksumProducer.ChecksumType == ChecksumType
    {
        return try targets.values.sorted().map {
            try $0.obtainChecksum(checksumProducer: checksumProducer)
        }.aggregate()
    }
    
    func reflectUpdate(updateModel: ProjectUpdateModel) throws {
        let cache = ThreadSafeDictionary<PBXTarget, TargetChecksumHolder<ChecksumType>>()
        let targetUpdateModelsDictionary = updateModel.project.targets
            .map { target in
                TargetUpdateModel<ChecksumType>(
                    target: target,
                    sourceRoot: updateModel.sourceRoot,
                    cache: cache
                )
            }.keyValue { $0.name }
        let shouldInvalidate = try targetUpdateModelsDictionary.update(
            childrenDictionary: &targets,
            update: { targetChecksumHolder, targetUpdateModel in
                try targetChecksumHolder.reflectUpdate(updateModel: targetUpdateModel)
            }, buildValue: { targetUpdateModel in
                TargetChecksumHolder<ChecksumType>(
                    updateModel: targetUpdateModel,
                    parent: self
                )
            }
        )
        if shouldInvalidate {
            invalidate()
        }        
    }

}
