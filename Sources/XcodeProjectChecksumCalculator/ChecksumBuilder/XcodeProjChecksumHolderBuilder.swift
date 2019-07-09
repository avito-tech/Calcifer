import Foundation
import XcodeProjCache
import XcodeProj
import Checksum
import PathKit
import Toolkit

final class XcodeProjChecksumHolderBuilder<ChecksumProducer: URLChecksumProducer> {
    
    private let builder: ProjChecksumHolderBuilder<ChecksumProducer>
    private let xcodeProjCache: XcodeProjCache
    
    init(
        builder: ProjChecksumHolderBuilder<ChecksumProducer>,
        xcodeProjCache: XcodeProjCache)
    {
        self.builder = builder
        self.xcodeProjCache = xcodeProjCache
    }
    
    func build(xcodeProj: XcodeProj, projectPath: String) throws -> XcodeProjChecksumHolder<ChecksumProducer.ChecksumType> {
        let pbxproj = xcodeProj.pbxproj
        let path = Path(projectPath)
        let sourceRoot = Path(components: Array(path.components.dropLast()))
        
        let xcodeProjChecksumHolder = XcodeProjChecksumHolder<ChecksumProducer.ChecksumType>(
            name: path.url.path
        )
        
        let projChecksum = try builder.build(parent: xcodeProjChecksumHolder, pbxproj: pbxproj, sourceRoot: sourceRoot)
        xcodeProjChecksumHolder.update(proj: projChecksum)
        
        return xcodeProjChecksumHolder
    }
}
