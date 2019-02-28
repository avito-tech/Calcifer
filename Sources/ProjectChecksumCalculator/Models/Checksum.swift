import Foundation

public protocol Combinable: Equatable {
    static func + (_ left: Self, _ right: Self) throws -> Self
    static var zero: Self { get }
}

public protocol Checksum: CustomStringConvertible, Hashable, Combinable {}
