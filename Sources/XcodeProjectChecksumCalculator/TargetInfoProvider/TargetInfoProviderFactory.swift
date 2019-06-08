import Foundation
import XcodeProjCache
import Checksum
import Toolkit

public final class TargetInfoProviderFactory<ChecksumProducer: URLChecksumProducer> {
    
    private let fileManager: FileManager
    private let checksumProducer: ChecksumProducer
    private let factory = XcodeProjChecksumHolderBuilderFactory(
        fullPathProvider: BaseFileElementFullPathProvider(),
        xcodeProjCache: XcodeProjCacheImpl.shared
    )
    
    public init(
        fileManager: FileManager,
        checksumProducer: ChecksumProducer)
    {
        self.fileManager = fileManager
        self.checksumProducer = checksumProducer
    }
    
    public func targetChecksumProvider(
        projectPath: String)
        throws -> TargetInfoProvider<ChecksumProducer.ChecksumType>
    {
        let builder = factory.projChecksumHolderBuilder(
            checksumProducer: checksumProducer
        )
        let checksumHolder = try builder.build(projectPath: projectPath)
        Logger.info("XcodeProj checksum: \(checksumHolder.checksum.stringValue) for \(checksumHolder.description)")
        let provider = TargetInfoProvider(
            checksumHolder: checksumHolder
        )
        return provider
    }
    
}
