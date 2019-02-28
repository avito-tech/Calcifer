import Foundation

final class XcodeProjChecksumHolderBuilderFactory {
    
    init() {}
    
    func projChecksumHolderBuilder<ChecksumProducer: URLChecksumProducer>(checksumProducer: ChecksumProducer)
        -> XcodeProjChecksumHolderBuilder<ChecksumProducer>
    {
        let fileChecksumBuilder = FileChecksumHolderBuilder(checksumProducer: checksumProducer)
        let targetChecksumBuilder = TargetChecksumHolderBuilder(builder: fileChecksumBuilder)
        let projectChecksumBuilder = ProjectChecksumHolderBuilder(builder: targetChecksumBuilder)
        let projChecksumBuilder  = ProjChecksumHolderBuilder(builder: projectChecksumBuilder)
        return XcodeProjChecksumHolderBuilder(builder: projChecksumBuilder)
    }
}
