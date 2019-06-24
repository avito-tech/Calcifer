import Foundation

public final class StackKeyValueStorageImpl<Key: Hashable, Value>: StackKeyValueStorage {
    
    private var cache = [Key: [Value]]()
    
    public init() {}
    
    public func obtain(for key: Key) -> Value? {
        var cachedValues = cache[key]
        let first = cachedValues?.first
        if cachedValues?.isEmpty == false {
            cachedValues?.removeFirst()
        }
        cache[key] = cachedValues
        return first
    }
    
    public func clear(for key: Key, predicate: (Value) -> (Bool)) {
        let cleared = cache[key]?.filter { predicate($0) }
        cache[key] = cleared
    }
    
    public func addValue(_ value: Value, for key: Key) {
        var values = cache[key] ?? [Value]()
        values.append(value)
        cache[key] = values
    }
    
}
