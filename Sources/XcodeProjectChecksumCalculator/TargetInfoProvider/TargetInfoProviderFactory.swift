import Foundation
import Checksum

public final class TargetInfoProviderFactory<ChecksumProducer: URLChecksumProducer> {
    
    private let checksumProducer: ChecksumProducer
    
    public init(checksumProducer: ChecksumProducer) {
        self.checksumProducer = checksumProducer
    }
    
    public func targetChecksumProvider(projectPath: String) throws -> TargetInfoProvider<ChecksumProducer.ChecksumType> {
        let builder = XcodeProjChecksumHolderBuilderFactory().projChecksumHolderBuilder(
            checksumProducer: checksumProducer
        )
        let checksumHolder = try builder.build(projectPath: projectPath)
        return TargetInfoProvider(
            checksumHolder: checksumHolder
        )
    }
    
}
