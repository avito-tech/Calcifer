import Foundation
import xcodeproj
import Checksum
import PathKit

final class FileChecksumHolderBuilder<ChecksumProducer: URLChecksumProducer> {
    
    let checksumProducer: ChecksumProducer
    let fullPathProvider: FileElementFullPathProvider
    
    init(
        checksumProducer: ChecksumProducer,
        fullPathProvider: FileElementFullPathProvider)
    {
        self.checksumProducer = checksumProducer
        self.fullPathProvider = fullPathProvider
    }
    
    func build(file: PBXFileElement, sourceRoot: Path) throws -> FileChecksumHolder<ChecksumProducer.ChecksumType> {
        let filePath = try fullPathProvider.fullPath(for: file, sourceRoot: sourceRoot)
        return FileChecksumHolder(
            description: filePath.string,
            checksum: try checksumProducer.checksum(input: filePath.url)
        )
    }

}
