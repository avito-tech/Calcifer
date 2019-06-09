import Foundation

public extension DispatchGroup {
    @discardableResult
    static func wait<T>(_ action: (DispatchGroup) throws -> (T)) rethrows -> T {
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        let result = try action(dispatchGroup)
        dispatchGroup.wait()
        return result
    }
}
