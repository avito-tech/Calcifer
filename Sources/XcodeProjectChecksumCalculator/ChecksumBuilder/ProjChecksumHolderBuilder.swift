import Foundation
import XcodeProj
import Checksum
import PathKit

final class ProjChecksumHolderBuilder<Builder: URLChecksumProducer> {
    
    let builder: ProjectChecksumHolderBuilder<Builder>
    
    init(builder: ProjectChecksumHolderBuilder<Builder>) {
        self.builder = builder
    }
    
    func build(
        parent: XcodeProjChecksumHolder<Builder.ChecksumType>,
        pbxproj: PBXProj,
        sourceRoot: Path)
        throws
        -> ProjChecksumHolder<Builder.ChecksumType>
    {
        let projChecksumHolder = ProjChecksumHolder<Builder.ChecksumType>(
            name: "pbxproj-\(pbxproj.objectVersion)-\(pbxproj.archiveVersion)",
            parent: parent
        )
        let projectsChecksums = try pbxproj.projects.map { project in
            try builder.build(
                parent: projChecksumHolder,
                project: project,
                sourceRoot: sourceRoot
            )
        }
        projChecksumHolder.update(projects: projectsChecksums)
        return projChecksumHolder
    }
}
