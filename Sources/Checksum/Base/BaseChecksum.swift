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
        let string = (left.stringValue + right.stringValue).md5()
        return BaseChecksum(string)
    }
    
    public static var zero: BaseChecksum {
        return BaseChecksum("")
    }
    
    public static func == (lhs: BaseChecksum, rhs: BaseChecksum) -> Bool {
        return lhs.stringValue == rhs.stringValue
    }
    
}
