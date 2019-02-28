import Foundation

protocol URLChecksumProducer: ChecksumProducer where Input == URL {}

final class BaseURLChecksumProducer: URLChecksumProducer {
    
    func checksum(input: URL) throws -> BaseChecksum {
        let string = try Data(contentsOf: input).md5()
        return BaseChecksum(string)
    }
    
}
