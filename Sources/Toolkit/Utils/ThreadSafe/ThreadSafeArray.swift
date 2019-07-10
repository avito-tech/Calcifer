import Foundation

public final class ThreadSafeArray<Value> {
    private let lock = NSLock()
    private var array = [Value]()
    
    public func append(_ value: Value) {
        lock.whileLocked {
            array.append(value)
        }
    }
    
    public var values: [Value] {
        return lock.whileLocked {
            Array(array)
        }
    }
}
