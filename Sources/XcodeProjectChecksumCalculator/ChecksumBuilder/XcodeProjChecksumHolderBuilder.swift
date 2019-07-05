import Foundation
import XcodeProjCache
import XcodeProj
import Checksum
import PathKit
import Toolkit

final class XcodeProjChecksumHolderBuilder<ChecksumProducer: URLChecksumProducer> {
    
    private let xcodeProjCache: XcodeProjCache
    
    init(xcodeProjCache: XcodeProjCache) {
        self.xcodeProjCache = xcodeProjCache
    }
    
    func build(xcodeProj: XcodeProj, projectPath: String) throws -> XcodeProjChecksumHolder<ChecksumProducer.ChecksumType> {
        
        let sourceRoot = Path(components: Array(Path(projectPath).components.dropLast()))
        let xcodeProjChecksumHolder = XcodeProjChecksumHolder<ChecksumProducer.ChecksumType>(
            name: projectPath
        )
        let xcodeProjUpdateModel = XcodeProjUpdateModel(
            xcodeProj: xcodeProj,
            projectPath: projectPath,
            sourceRoot: sourceRoot
        )
        try xcodeProjChecksumHolder.reflectUpdate(updateModel: xcodeProjUpdateModel)
        return xcodeProjChecksumHolder
    }
}
