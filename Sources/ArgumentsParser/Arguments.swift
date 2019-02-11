import Foundation

public enum ArgumentsError: Error, CustomStringConvertible {
    case argumentIsMissing(String)
    case argumentValueCannotBeUsed(String)
    
    public var description: String {
        switch self {
        case .argumentIsMissing(let name):
            return "Missing argument: \(name)"
        case .argumentValueCannotBeUsed(let argument):
            return "The provided value for argument '\(argument)'"
        }
    }
}
