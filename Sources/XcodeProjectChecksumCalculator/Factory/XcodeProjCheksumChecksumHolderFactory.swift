import Foundation
import Checksum

public final class XcodeProjChecksumHolderBuilderFactory {
    
    private let fullPathProvider: FileElementFullPathProvider
    
    init(fullPathProvider: FileElementFullPathProvider) {
        self.fullPathProvider = fullPathProvider
    }
    
    func projChecksumHolderBuilder<ChecksumProducer: URLChecksumProducer>(
        checksumProducer: ChecksumProducer)
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
