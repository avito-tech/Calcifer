import Foundation

extension NSLock {
    public func whileLocked<T> (_ body: () throws -> T) rethrows -> T {
        lock()
        defer { unlock() }
        return try body()
    }
}
