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
    
    static func + (left: TestChecksum, right: TestChecksum) throws -> TestChecksum {
        return TestChecksum(left.stringValue + right.stringValue)
    }
    
    static var zero: TestChecksum {
        return TestChecksum("")
    }
    
    static func == (lhs: TestChecksum, rhs: TestChecksum) -> Bool {
        return lhs.stringValue == rhs.stringValue
    }
    
    static func < (lhs: TestChecksum, rhs: TestChecksum) -> Bool {
        return lhs.stringValue < rhs.stringValue
    }
}
