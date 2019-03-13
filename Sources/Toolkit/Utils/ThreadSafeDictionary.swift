import Foundation
import Basic

public final class ThreadSafeDictionary<Key: Hashable, Value> {
    
    private let lock = Lock()
    private var dictionary = [Key: Value]()
    
    public private(set) lazy var read: (Key) -> (Value?) = { key in
        self.lock.withLock { [weak self] in
            self?.dictionary[key]
        }
    }
    
    public private(set) lazy var write: (Key, Value) -> () = { key, value in
        // In this situation, it is more correct to use the DispatchQueue, not the lock, but DispatchQueue works twice as long.
        self.lock.withLock { [weak self] in
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
