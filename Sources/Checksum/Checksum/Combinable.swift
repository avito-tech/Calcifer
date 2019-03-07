import Foundation

public protocol Combinable: Equatable {
    static func + (_ left: Self, _ right: Self) throws -> Self
    static var zero: Self { get }
}
