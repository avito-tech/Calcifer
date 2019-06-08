import Foundation

public extension DispatchGroup {
    @discardableResult
    func wait<T>(_ action: (DispatchGroup) throws -> (T)) rethrows -> T {
        enter()
        let result = try action(self)
        wait()
        return result
    }
}
