import Foundation
import Checksum

final class XcodeProjChecksumHolderBuilderFactory {
    
    init() {}
    
    func projChecksumHolderBuilder<ChecksumProducer: URLChecksumProducer>(
        checksumProducer: ChecksumProducer,
        fullPathProvider: FileElementFullPathProvider = BaseFileElementFullPathProvider())
        -> XcodeProjChecksumHolderBuilder<ChecksumProducer>
    {
        let fileChecksumBuilder = FileChecksumHolderBuilder(
            checksumProducer: checksumProducer,
            fullPathProvider: fullPathProvider
        )
        let targetChecksumBuilder = TargetChecksumHolderBuilder(builder: fileChecksumBuilder)
        let projectChecksumBuilder = ProjectChecksumHolderBuilder(builder: targetChecksumBuilder)
        let projChecksumBuilder = ProjChecksumHolderBuilder(builder: projectChecksumBuilder)
        return XcodeProjChecksumHolderBuilder(builder: projChecksumBuilder)
    }
}
