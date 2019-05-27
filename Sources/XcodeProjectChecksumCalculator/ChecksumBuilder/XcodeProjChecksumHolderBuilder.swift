import Foundation
import XcodeProjCache
import xcodeproj
import Checksum
import PathKit

final class XcodeProjChecksumHolderBuilder<Builder: URLChecksumProducer> {
    
    private let builder: ProjChecksumHolderBuilder<Builder>
    private let xcodeProjCache: XcodeProjCache
    
    init(
        builder: ProjChecksumHolderBuilder<Builder>,
        xcodeProjCache: XcodeProjCache)
    {
        self.builder = builder
        self.xcodeProjCache = xcodeProjCache
    }
    
    func build(projectPath: String) throws -> XcodeProjChecksumHolder<Builder.ChecksumType> {
        let xcodeproject = try xcodeProjCache.obtainXcodeProj(projectPath: projectPath)
        let pbxproj = xcodeproject.pbxproj
        let path = Path(projectPath)
        let sourceRoot = Path(components: Array(path.components.dropLast()))
        let projChecksum = try builder.build(pbxproj: pbxproj, sourceRoot: sourceRoot)
        return XcodeProjChecksumHolder(
            proj: projChecksum,
            description: projectPath,
            checksum: projChecksum.checksum
        )
    }
}
