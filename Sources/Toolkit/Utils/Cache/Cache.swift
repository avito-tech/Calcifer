import Foundation

public protocol Cache {
    associatedtype Key: Hashable
    associatedtype Value
    func obtain(for key: Key) -> Value?
}
