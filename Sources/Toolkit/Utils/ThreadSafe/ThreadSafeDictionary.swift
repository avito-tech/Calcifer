import Foundation

public final class ThreadSafeDictionary<Key: Hashable, Value> {
    
    public enum KeyResult {
        case exists(Value)
        case created(Value)
        
        public var value: Value {
            switch self {
            case let .exists(value):
                return value
            case let .created(value):
                return value
            }
        }
        
        public var exist: Bool {
            switch self {
            case .exists:
                return true
            case .created:
                return false
            }
        }
        
        public var created: Bool {
            switch self {
            case .exists:
                return false
            case .created:
                return true
            }
        }
    }
    
    private let lock = NSLock()
    private var dictionary: [Key: Value]
    
    public init(dictionary: [Key: Value] = [:]) {
        self.dictionary = dictionary
    }
    
    public func read(_ key: Key) -> Value? {
        return lock.whileLocked {
            dictionary[key]
        }
    }
    
    @discardableResult
    public func createIfNotExist(
        _ key: Key,
        create: (Key) throws -> (Value))
        rethrows -> KeyResult
    {
        return try lock.whileLocked {
            guard let value = dictionary[key] else {
                let value = try create(key)
                dictionary[key] = value
                return .created(value)
            }
            return .exists(value)
        }
    }
    
    @discardableResult
    public func createIfNotExist(
        _ key: Key,
        _ value: @autoclosure () throws -> (Value))
        rethrows -> KeyResult
    {
        return try createIfNotExist(key) { _ in
            return try value()
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
    
    public var count: Int {
        return lock.whileLocked {
            dictionary.count
        }
    }
    
    public func enumerateKeysAndObjects(
        options: NSEnumerationOptions = [],
        iterator: (Key, Value, inout Bool) throws -> Void)
        throws
    {
        return try lock.whileLocked {
            try dictionary.enumerateKeysAndObjects(
                options: options,
                iterator: iterator
            )
        }
    }
    
    public func forEach(_ body: ((key: Key, value: Value)) throws -> Void) rethrows {
        return try lock.whileLocked {
            try dictionary.forEach(body)
        }
    }
    
    public func map<T>(_ transform: ((key: Key, value: Value)) throws -> T) rethrows -> [T] {
        return try lock.whileLocked {
            try dictionary.map(transform)
        }
    }
    
    public func cast<NK, NV>(_ transform: ([Key: Value]) -> ([NK: NV])) -> ThreadSafeDictionary<NK, NV> {
        return lock.whileLocked {
            ThreadSafeDictionary<NK, NV>(dictionary: transform(dictionary))
        }
    }
    
}
