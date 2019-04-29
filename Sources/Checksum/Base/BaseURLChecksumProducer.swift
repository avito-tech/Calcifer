import Foundation
import PathKit
import Toolkit

public protocol URLChecksumProducer: ChecksumProducer where Input == URL {}

public final class BaseURLChecksumProducer: URLChecksumProducer {
    
    private let fileManager: FileManager
    
    public init(fileManager: FileManager) {
        self.fileManager = fileManager
    }
    
    public func checksum(input: URL) throws -> BaseChecksum {
        let filesChecksum = try fileManager.files(at: input.path)
            .map { URL(fileURLWithPath: $0) }
            .map { checksum(for: $0) }
            .aggregate()
        if filesChecksum == .zero {
            throw ChecksumError.zeroChecksum(path: input.path)
        }
        return filesChecksum
    }
    
    private func checksum(for file: URL) -> BaseChecksum {
        // TODO: Read file by сhunk ( Chunk.md5() + Chunk.md5() )
        let data = catchError { try Data(contentsOf: file) }
        let string = data.md5()
        return BaseChecksum(string)
    }
    
}
