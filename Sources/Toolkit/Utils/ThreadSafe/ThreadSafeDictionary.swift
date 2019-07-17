import Foundation

public final class ThreadSafeDictionary<Key: Hashable, Value> {
    
    private let lock = NSLock()
    private var dictionary = [Key: Value]()
    
    public init(dictionary: [Key: Value] = [:]) {
        self.dictionary = dictionary
    }
    
    public func read(_ key: Key) -> Value? {
        return lock.whileLocked {
            dictionary[key]
        }
    }
    
    @discardableResult
    public func createIfNotExist(_ key: Key, create: (Key) throws -> (Value)) rethrows -> Value {
        return try lock.whileLocked {
            guard let value = dictionary[key] else {
                let value = try create(key)
                dictionary[key] = value
                return value
            }
            return value
        }
    }
    
    public func write(_ value: Value, for key: Key) {
        // In this situation, it is more correct to use the DispatchQueue, not the lock, but DispatchQueue works twice as long.
        lock.whileLocked {
            dictionary[key] = value
        }
    }
    
    public func removeValue(forKey key: Key) {
        lock.whileLocked {
            dictionary.removeValue(forKey: key)
        }
    }
    
    public var values: [Value] {
        return lock.whileLocked {
            Array(dictionary.values)
        }
    }
    
    public var keys: [Key] {
        return lock.whileLocked {
            Array(dictionary.keys)
        }
    }
    
    public var isEmpty: Bool {
        return lock.whileLocked {
            dictionary.isEmpty
        }
    }
    
    public func obtainDictionary() -> [Key: Value] {
        return lock.whileLocked {
            dictionary
        }
    }
    
}
