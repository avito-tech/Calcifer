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
    
    public static func + (left: BaseChecksum, right: BaseChecksum) throws -> BaseChecksum {
        if left == .zero {
            return right
        }
        if right == .zero {
            return left
        }
        let stringValue = left.stringValue + right.stringValue
        let stringChecksum = stringValue.md5()
        return BaseChecksum(stringChecksum)
    }
    
    public static var zero: BaseChecksum {
        return BaseChecksum("")
    }
    
    public static func == (lhs: BaseChecksum, rhs: BaseChecksum) -> Bool {
        return lhs.stringValue == rhs.stringValue
    }
    
    public static func < (lhs: BaseChecksum, rhs: BaseChecksum) -> Bool {
        return lhs.stringValue < rhs.stringValue
    }
    
}
