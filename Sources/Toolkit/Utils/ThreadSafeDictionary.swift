import Foundation
import Basic

public final class ThreadSafeDictionary<Key: Hashable, Value> {
    
    private let lock = Lock()
    private var dictionary = [Key: Value]()
    
    public func read(_ key: Key) -> (Value?) {
        return lock.withLock { [weak self] in
            self?.dictionary[key]
        }
    }
    
    public func write(_ value: Value, for key: Key) {
        // In this situation, it is more correct to use the DispatchQueue, not the lock, but DispatchQueue works twice as long.
        lock.withLock { [weak self] in
            self?.dictionary[key] = value
        }
    }
    
    public var values: [Value] {
        return lock.withLock {
            Array(dictionary.values)
        }
    }
    
    public init() {}
    
}
