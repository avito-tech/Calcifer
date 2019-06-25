import Foundation
import XcodeProjCache
import XcodeProj
import Checksum
import PathKit
import Toolkit

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
        let xcodeproject = try TimeProfiler.measure("Obtain XcodeProj") {
            try xcodeProjCache.obtainXcodeProj(projectPath: projectPath)
        }
        let pbxproj = xcodeproject.pbxproj
        let path = Path(projectPath)
        let sourceRoot = Path(components: Array(path.components.dropLast()))
        let projChecksum = try TimeProfiler.measure("Build XcodeProj checksum") {
            try builder.build(pbxproj: pbxproj, sourceRoot: sourceRoot)
        }
        return XcodeProjChecksumHolder(
            proj: projChecksum,
            description: projectPath,
            checksum: projChecksum.checksum
        )
    }
}
