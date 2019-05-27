import Foundation
import Checksum
import Toolkit

public final class TargetInfoProviderFactory<ChecksumProducer: URLChecksumProducer> {
    
    private let checksumProducer: ChecksumProducer
    private let fileManager: FileManager
    
    private let factory = XcodeProjChecksumHolderBuilderFactory(
        fullPathProvider: BaseFileElementFullPathProvider()
    )
    private let queue = DispatchQueue(label: "XcodeProjChecksumHolderManager")
    private var storage = [String: TargetInfoProviderCache<ChecksumProducer.ChecksumType>]()
    
    public init(checksumProducer: ChecksumProducer, fileManager: FileManager) {
        self.checksumProducer = checksumProducer
        self.fileManager = fileManager
    }
    
    public func targetChecksumProvider(
        projectPath: String)
        throws -> TargetInfoProvider<ChecksumProducer.ChecksumType>
    {
        return try queue.sync {
            let checksum = try obtainChecksum(for: projectPath)
            if let cachedProvider = storage[projectPath], cachedProvider.checksum == checksum {
                return cachedProvider.targetInfoProvider
            }
            let provider = try createProvider(for: projectPath)
            storage[projectPath] = TargetInfoProviderCache(
                targetInfoProvider: provider,
                checksum: checksum,
                projectPath: projectPath
            )
            return provider
        }
    }
    
    private func obtainChecksum(for projectPath: String) throws -> ChecksumProducer.ChecksumType {
        let pbxprojPath = projectPath.appendingPathComponent("project.pbxproj")
        let pbxprojURL = URL(fileURLWithPath: pbxprojPath)
        let checksum = try checksumProducer.checksum(input: pbxprojURL)
        return checksum
    }
    
    private func createProvider(
        for projectPath: String)
        throws -> TargetInfoProvider<ChecksumProducer.ChecksumType>
    {
        let builder = factory.projChecksumHolderBuilder(
            checksumProducer: checksumProducer
        )
        let checksumHolder = try builder.build(projectPath: projectPath)
        
        Logger.info("XcodeProj checksum: \(checksumHolder.checksum.stringValue) for \(checksumHolder.description)")
        
        let provider = TargetInfoProvider(
            checksumHolder: checksumHolder,
            fileManager: fileManager
        )
        
        return provider
    }
    
}
