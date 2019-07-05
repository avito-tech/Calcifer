import Foundation
import XcodeProjCache
import Checksum

final class XcodeProjChecksumHolderBuilderFactory {
    
    private let fullPathProvider: FileElementFullPathProvider
    private let xcodeProjCache: XcodeProjCache
    
    init(fullPathProvider: FileElementFullPathProvider, xcodeProjCache: XcodeProjCache) {
        self.fullPathProvider = fullPathProvider
        self.xcodeProjCache = xcodeProjCache
    }
    
    func projChecksumHolderBuilder<ChecksumProducer: URLChecksumProducer>(
        checksumProducer: ChecksumProducer)
        -> XcodeProjChecksumHolderBuilder<ChecksumProducer>
    {
//        let fileChecksumBuilder = FileChecksumHolderBuilder(
//            checksumProducer: checksumProducer,
//            fullPathProvider: fullPathProvider
//        )
//        let targetChecksumBuilder = TargetChecksumHolderBuilder(fullPathProvider: fullPathProvider)
//        let projectChecksumBuilder = ProjectChecksumHolderBuilder(builder: targetChecksumBuilder)
//        let projChecksumBuilder = ProjChecksumHolderBuilder(builder: projectChecksumBuilder)
        return XcodeProjChecksumHolderBuilder(
//            builder: projChecksumBuilder,
            xcodeProjCache: xcodeProjCache
        )
    }
}
