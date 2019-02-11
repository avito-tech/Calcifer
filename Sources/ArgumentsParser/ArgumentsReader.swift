import Foundation

public final class ArgumentsReader {

    public static func validateNotNil<T>(_ value: T?, name: String) throws -> T {
        guard let value = value else { throw ArgumentsError.argumentIsMissing(name) }
        return value
    }

}
