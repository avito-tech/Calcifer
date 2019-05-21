import Foundation
import Checksum
import Toolkit

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
        
        Logger.info("XcodeProj checksum: \(checksumHolder.checksum.stringValue) for \(checksumHolder.description)")
        
        return TargetInfoProvider(
            checksumHolder: checksumHolder,
            fileManager: fileManager
        )
    }
    
    
    
}
