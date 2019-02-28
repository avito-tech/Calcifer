import Foundation
import xcodeproj
import PathKit

final class FileChecksumHolderBuilder<ChecksumProducer: URLChecksumProducer> {
    
    let checksumProducer: ChecksumProducer
    
    init(checksumProducer: ChecksumProducer) {
        self.checksumProducer = checksumProducer
    }
    
    func build(file: PBXFileElement, sourceRoot: Path) throws -> FileChecksumHolder<ChecksumProducer.C> {
        let filePath = try obtainPath(for: file, sourceRoot: sourceRoot)
        return FileChecksumHolder(
            objectDescription: filePath.string,
            checksum: try checksumProducer.checksum(input: filePath.url)
        )
    }
    
    private func obtainPath(for file: PBXFileElement, sourceRoot: Path) throws -> Path {
        guard let filePath = try file.fullPath(sourceRoot: sourceRoot) else {
            throw ProjectChecksumError.emptyFullFilePath(
                name: file.name,
                path: file.path
            )
        }
        return filePath
    }
}
