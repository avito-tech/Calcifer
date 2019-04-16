import Foundation

public func catchError<T>(_ action: () throws -> (T)) -> T {
    do {
        return try action()
    } catch {
        Logger.error(error.localizedDescription)
        fatalError()
    }
}
