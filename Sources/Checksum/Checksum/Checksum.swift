import Foundation

public protocol Checksum: CustomStringConvertible, Hashable, Combinable, Codable {
    var stringValue: String { get }
}
