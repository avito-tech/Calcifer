import Foundation

public protocol Checksum: CustomStringConvertible, Hashable, Codable {
    var stringValue: String { get }
    
    func combine(other: Self) -> Self
}
