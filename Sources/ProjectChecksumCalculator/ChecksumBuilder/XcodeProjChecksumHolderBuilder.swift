import Foundation
import xcodeproj
import Checksum
import PathKit

final class XcodeProjChecksumHolderBuilder<Builder: URLChecksumProducer> {
    
    let builder: ProjChecksumHolderBuilder<Builder>
    
    init(builder: ProjChecksumHolderBuilder<Builder>) {
        self.builder = builder
    }
    
    func build(projectPath: String) throws -> XcodeProjChecksumHolder<Builder.C> {
        let path = Path(projectPath)
        let xcodeproject = try XcodeProj(path: path)
        let pbxproj = xcodeproject.pbxproj
        let sourceRoot = Path(components: Array(path.components.dropLast()))
        let projChecksum = try builder.build(pbxproj: pbxproj, sourceRoot: sourceRoot)
        return XcodeProjChecksumHolder(
            proj: projChecksum,
            description: projectPath,
            checksum: projChecksum.checksum
        )
    }
}
