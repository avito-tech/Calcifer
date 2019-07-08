import Foundation

public protocol Checksum: CustomStringConvertible, Hashable, Combinable, Codable, Comparable {
    var stringValue: String { get }
}
