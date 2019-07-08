import Foundation

public final class ThreadSafeDictionary<Key: Hashable, Value> {
    
    private let lock = NSLock()
    private var dictionary = [Key: Value]()
    
    public func read(_ key: Key) -> (Value?) {
        return lock.withLock {
            dictionary[key]
        }
    }
    
    public func write(_ value: Value, for key: Key) {
        // In this situation, it is more correct to use the DispatchQueue, not the lock, but DispatchQueue works twice as long.
        lock.withLock {
            dictionary[key] = value
        }
    }
    
    public var values: [Value] {
        return lock.withLock {
            Array(dictionary.values)
        }
    }
    
    public init() {}
    
}


extension NSLock {
    public func withLock<T> (_ body: () throws -> T) rethrows -> T {
        lock()
        defer { unlock() }
        return try body()
    }
}
