import Foundation

final class BaseChecksum: Checksum {
    
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
    
    static func + (left: BaseChecksum, right: BaseChecksum) throws -> BaseChecksum {
        guard let string = try (left.stringValue + right.stringValue).md5() else {
            throw ProjectChecksumCalculatorError.emptyChecksum
        }
        return BaseChecksum(string)
    }
    
    static var zero: BaseChecksum {
        return BaseChecksum("")
    }
    
    static func == (lhs: BaseChecksum, rhs: BaseChecksum) -> Bool {
        return lhs.stringValue == rhs.stringValue
    }
}
