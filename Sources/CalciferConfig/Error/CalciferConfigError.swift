import Foundation

public enum CalciferConfigError: Error, CustomStringConvertible {
    case unableToParseConfig(path: String)
    
    public var description: String {
        switch self {
        case let .unableToParseConfig(path):
            return "Unable to parse config at path \(path)"
        }
    }
}
