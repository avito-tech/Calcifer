import Foundation
import PathKit
import Toolkit

open class URLChecksumProducer<ChecksumType: Checksum>: ChecksumProducer {
    
    public init() {}
    
    open func checksum(input: URL) throws -> ChecksumType {
        fatalError("Must be overriden")
    }
    
}

public final class BaseURLChecksumProducer: URLChecksumProducer<BaseChecksum> {
    
    struct URLChecksumValue {
        let checksum: BaseChecksum
        let modificationDate: Date
    }
    
    private let cache = ThreadSafeDictionary<URL, URLChecksumValue>()
    
    private let fileManager: FileManager
    
    public init(fileManager: FileManager) {
        self.fileManager = fileManager
    }
    
    override public func checksum(input: URL) throws -> BaseChecksum {
        let filesChecksum = try fileManager.files(at: input.path)
            .map { URL(fileURLWithPath: $0) }
            .map { try obtainChecksum(for: $0) }
            .aggregate()
        if filesChecksum == .zero {
            throw ChecksumError.zeroChecksum(path: input.path)
        }
        return filesChecksum
    }
    
    private func obtainChecksum(for file: URL) throws -> BaseChecksum {
        let modificationDate = try fileManager.modificationDate(at: file.path)
        guard let cached = cache.read(file),
            cached.modificationDate == modificationDate
            else {
                let checksum = try calculateChecksum(for: file)
                cache.write(
                    URLChecksumValue(
                        checksum: checksum,
                        modificationDate: modificationDate
                    ),
                    for: file
                )
                return checksum
        }
        
        return cached.checksum
    }
    
    private func calculateChecksum(for file: URL) throws -> BaseChecksum {
        // TODO: Read file by chunk ( Chunk.md5() + Chunk.md5() )
        let data = try Data(contentsOf: file)
        let string = data.md5()
        return BaseChecksum(string)
    }
    
}
