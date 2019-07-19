import Foundation

extension NSLock {
    @discardableResult
    public func whileLocked<T> (_ body: () throws -> T) rethrows -> T {
        lock()
        defer { unlock() }
        return try body()
    }
}
