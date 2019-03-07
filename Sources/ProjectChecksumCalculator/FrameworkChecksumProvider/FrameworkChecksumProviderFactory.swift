import Foundation
import Checksum

public final class FrameworkChecksumProviderFactory<ChecksumProducer: URLChecksumProducer> {
    
    private let checksumProducer: ChecksumProducer
    
    public init(checksumProducer: ChecksumProducer) {
        self.checksumProducer = checksumProducer
    }
    
    public func frameworkChecksumProvider(projectPath: String) throws -> TargetChecksumProvider<ChecksumProducer.ChecksumType> {
        let builder = XcodeProjChecksumHolderBuilderFactory().projChecksumHolderBuilder(
            checksumProducer: checksumProducer
        )
        let checksumHolder = try builder.build(projectPath: projectPath)
        return TargetChecksumProvider(
            checksumHolder: checksumHolder
        )
    }
    
}
