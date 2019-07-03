import Foundation

@discardableResult
public func catchError<T>(
    _ file: String = #file,
    _ function: String = #function,
    _ line: Int = #line,
    _ action: () throws -> (T))
    -> T
{
    do {
        return try action()
    } catch {
        Logger.error(error.localizedDescription, file, function, line)
        fatalError(error.localizedDescription)
    }
}
