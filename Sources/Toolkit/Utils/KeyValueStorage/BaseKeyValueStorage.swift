import Foundation

public final class BaseKeyValueStorage<Key: Hashable, Value>: MutableKeyValueStorage  {
    
    private var cache = [Key: Value]()
    
    public init() {}
    
    public func obtain(for key: Key) -> Value? {
        return cache[key]
    }
    
    public func addValue(_ value: Value, for key: Key) {
        cache[key] = value
    }
    
}
