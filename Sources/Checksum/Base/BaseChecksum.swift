import Foundation
import Toolkit

public final class BaseChecksum: Checksum {
    
    public let stringValue: String
    
    public init(_ stringValue: String) {
        self.stringValue = stringValue
    }
    
    public var description: String {
        return stringValue
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(stringValue)
    }
    
    public func combine(other: BaseChecksum) -> BaseChecksum {
        let stringValue = self.stringValue + other.stringValue
        let stringChecksum = stringValue.md5()
        return BaseChecksum(stringChecksum)
    }
    
    public static func == (lhs: BaseChecksum, rhs: BaseChecksum) -> Bool {
        return lhs.stringValue == rhs.stringValue
    }
}
