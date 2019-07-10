import Foundation

public final class ThreadSafeKeyValueStorage<Key: Hashable, Value> {
    
    private let lock = NSLock()
    private var cache = [Key: Value]()
    
    public init() {}
    
    public func obtain(for key: Key) -> Value? {
        return lock.whileLocked {
            cache[key]
        }
    }
    
    public func addValue(_ value: Value, for key: Key) {
        lock.whileLocked {
            cache[key] = value
        }
    }
    
}
