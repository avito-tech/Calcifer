import Foundation

public protocol KeyValueStorage {
    associatedtype Key: Hashable
    associatedtype Value
    func obtain(for key: Key) -> Value?
}
