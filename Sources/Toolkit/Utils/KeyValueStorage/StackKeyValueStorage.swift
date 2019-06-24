import Foundation

public protocol StackKeyValueStorage: MutableKeyValueStorage {
    func clear(for key: Key, predicate: (Value) -> (Bool))
}
