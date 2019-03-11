import Foundation
import Checksum

public final class TargetChecksumProviderFactory<ChecksumProducer: URLChecksumProducer> {
    
    private let checksumProducer: ChecksumProducer
    
    public init(checksumProducer: ChecksumProducer) {
        self.checksumProducer = checksumProducer
    }
    
    public func targetChecksumProvider(projectPath: String) throws -> TargetChecksumProvider<ChecksumProducer.ChecksumType> {
        let builder = XcodeProjChecksumHolderBuilderFactory().projChecksumHolderBuilder(
            checksumProducer: checksumProducer
        )
        let checksumHolder = try builder.build(projectPath: projectPath)
        return TargetChecksumProvider(
            checksumHolder: checksumHolder
        )
    }
    
}
