import Foundation
import Checksum
import XcodeProj
import PathKit

class ProjChecksumHolder<ChecksumType: Checksum>: BaseChecksumHolder<ChecksumType> {
    
    var projects = [String: ProjectChecksumHolder<ChecksumType>]()
    
    override var children: [String: BaseChecksumHolder<ChecksumType>] {
        return projects
    }
    
    init(name: String, parent: XcodeProjChecksumHolder<ChecksumType>) {
        super.init(name: name, parent: parent)
    }
    
    override public func calculateChecksum<ChecksumProducer: URLChecksumProducer>(checksumProducer: ChecksumProducer)
        throws -> ChecksumType
        where ChecksumProducer.ChecksumType == ChecksumType
    {
        return try projects.values.sorted().map {
            try $0.obtainChecksum(checksumProducer: checksumProducer)
        }.aggregate()
    }
    
    func update(projectsChecksums: [ProjectChecksumHolder<ChecksumType>]) {
        self.projects = Dictionary(uniqueKeysWithValues: projectsChecksums.map { ($0.name, $0) })
    }
    
    func reflectUpdate(updateModel: ProjUpdateModel) throws {
        let projectUpdateModelsDictionary = updateModel.proj.projects
            .map { project in
                ProjectUpdateModel(
                    project: project,
                    sourceRoot: updateModel.sourceRoot
                )
            }.keyValue { $0.name }
        let shouldInvalidate = try projectUpdateModelsDictionary.update(
            childrenDictionary: &projects,
            update: { projectChecksumHolder, projectUpdateModel in
                try projectChecksumHolder.reflectUpdate(updateModel: projectUpdateModel)
            }, buildValue: { projectUpdateModel in
                ProjectChecksumHolder(
                    name: projectUpdateModel.name,
                    parent: self
                )
            }
        )
        if shouldInvalidate {
            invalidate()
        }
    }
}
