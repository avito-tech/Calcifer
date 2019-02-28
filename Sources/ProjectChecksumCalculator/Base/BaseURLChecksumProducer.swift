import Foundation

final class BaseURLChecksumProducer: URLChecksumProducer {
    
    func checksum(for fileURL: URL) throws -> BaseChecksum {
        let string = try Data(contentsOf: fileURL).md5()
        return BaseChecksum(string)
    }
    
}
