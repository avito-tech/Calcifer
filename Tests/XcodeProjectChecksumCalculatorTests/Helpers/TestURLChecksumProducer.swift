import Foundation
import Checksum
@testable import XcodeProjectChecksumCalculator

final class TestURLChecksumProducer: URLChecksumProducer<TestChecksum> {
    
    override func checksum(input: URL) throws -> TestChecksum {
        return TestChecksum(input.absoluteString)
    }
    
}
