import Foundation

public protocol StackCache: MutableCache {
    func clear(for key: Key, predicate: (Value) -> (Bool))
}
