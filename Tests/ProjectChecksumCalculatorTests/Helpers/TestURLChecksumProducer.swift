import Foundation
import Checksum
@testable import ProjectChecksumCalculator

final class TestURLChecksumProducer: URLChecksumProducer {
    
    func checksum(input: URL) throws -> TestChecksum {
        return TestChecksum(input.absoluteString)
    }
    
}
