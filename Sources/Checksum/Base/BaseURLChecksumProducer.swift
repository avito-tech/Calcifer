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
    
    private let fileManager: FileManager
    
    public init(fileManager: FileManager) {
        self.fileManager = fileManager
    }
    
    public override func checksum(input: URL) throws -> BaseChecksum {
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
                let checksum = calculateChecksum(for: file)
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
    
    private func calculateChecksum(for file: URL) -> BaseChecksum {
        // TODO: Read file by сhunk ( Chunk.md5() + Chunk.md5() )
        let data = catchError { try Data(contentsOf: file) }
        let string = data.md5()
        return BaseChecksum(string)
    }
    
}
