import Foundation

public protocol MutableKeyValueStorage: KeyValueStorage {
    func addValue(_ value: Value, for key: Key)
}
