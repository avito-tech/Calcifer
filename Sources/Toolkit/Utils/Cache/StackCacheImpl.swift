import Foundation

public final class StackCacheImpl<Key: Hashable, Value>: StackCache {
    
    private var cache = [Key: [Value]]()
    
    public init() {}
    
    public func obtain(for key: Key) -> Value? {
        var cachedValues = cache[key]
        let first = cachedValues?.first
        cachedValues?.removeFirst()
        cache[key] = cachedValues
        return first
    }
    
    public func clear(for key: Key, when: (Value) -> (Bool)) {
        let cleared = cache[key]?.filter { when($0) }
        cache[key] = cleared
    }
    
    public func addValue(_ value: Value, for key: Key) {
        cache[key]?.append(value)
    }
    
}
