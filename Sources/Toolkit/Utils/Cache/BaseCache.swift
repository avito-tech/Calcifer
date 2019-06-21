import Foundation

public final class BaseCache<Key: Hashable, Value>: MutableCache  {
    
    private var cache = [Key: Value]()
    
    public init() {}
    
    public func obtain(for key: Key) -> Value? {
        return cache[key]
    }
    
    public func addValue(_ value: Value, for key: Key) {
        cache[key] = value
    }
    
}
