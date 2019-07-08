import Foundation
import Checksum
import XcodeProj
import PathKit
import Toolkit

final class ProjChecksumHolder<ChecksumType: Checksum>: BaseChecksumHolder<ChecksumType> {
    
    override var children: [String: BaseChecksumHolder<ChecksumType>] {
        return projects
    }
    
    var projects = [String: ProjectChecksumHolder<ChecksumType>]()
    
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
    
    override public func calculateChecksum() throws -> ChecksumType {
        return try projects.values.sorted().map {
            try $0.obtainChecksum()
        }.aggregate()
    }
    
    func update(projectsChecksums: [ProjectChecksumHolder<ChecksumType>]) {
        self.projects = Dictionary(uniqueKeysWithValues: projectsChecksums.map { ($0.name, $0) })
    }
    
    func reflectUpdate(updateModel: ProjUpdateModel<ChecksumType>) throws {
        let projectUpdateModelsDictionary = updateModel.proj.projects
            .map { project in
                ProjectUpdateModel(
                    project: project,
                    sourceRoot: updateModel.sourceRoot,
                    cache: updateModel.cache
                )
            }.keyValue { $0.name }
        let shouldInvalidate = try projectUpdateModelsDictionary.update(
            childrenDictionary: &projects,
            update: { projectChecksumHolder, projectUpdateModel in
                try projectChecksumHolder.reflectUpdate(updateModel: projectUpdateModel)
            }, buildValue: { projectUpdateModel in
                ProjectChecksumHolder(
                    name: projectUpdateModel.name,
                    parent: self,
                    fullPathProvider: fullPathProvider,
                    checksumProducer: checksumProducer
                )
            }
        )
        if shouldInvalidate {
            invalidate()
        }
    }
}
