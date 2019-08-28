import Foundation
import Checksum
@testable import XcodeProjectChecksumCalculator

final class TestChecksum: Checksum {
    
    let stringValue: String
    
    init(_ stringValue: String) {
        self.stringValue = stringValue
    }
    
    var description: String {
        return stringValue
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(stringValue)
    }
    
    func combine(other: TestChecksum) -> TestChecksum {
        return TestChecksum(self.stringValue + other.stringValue)
    }
    
    static func == (lhs: TestChecksum, rhs: TestChecksum) -> Bool {
        return lhs.stringValue == rhs.stringValue
    }
}
