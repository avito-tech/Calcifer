import Foundation
import Checksum

public final class TargetInfoProviderFactory<ChecksumProducer: URLChecksumProducer> {
    
    private let checksumProducer: ChecksumProducer
    private let fileManager: FileManager
    
    public init(checksumProducer: ChecksumProducer, fileManager: FileManager) {
        self.checksumProducer = checksumProducer
        self.fileManager = fileManager
    }
    
    public func targetChecksumProvider(
        projectPath: String)
        throws -> TargetInfoProvider<ChecksumProducer.ChecksumType>
    {
        let builder = XcodeProjChecksumHolderBuilderFactory().projChecksumHolderBuilder(
            checksumProducer: checksumProducer
        )
        let checksumHolder = try builder.build(projectPath: projectPath)
        
        return TargetInfoProvider(
            checksumHolder: checksumHolder,
            fileManager: fileManager
        )
    }
    
    
    
}
