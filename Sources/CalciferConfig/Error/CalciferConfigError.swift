import Foundation

public enum CalciferConfigError: Error, CustomStringConvertible {
    case unableToParseConfig(path: String)
    case emptyValueForKeyPath(keyPath: String, dictionary: [String: Any])
    
    public var description: String {
        switch self {
        case let .unableToParseConfig(path):
            return "Unable to parse config at path \(path)"
        case let .emptyValueForKeyPath(keyPath, dictionary):
            return "Empty value for key path \(keyPath) at dictionary \(dictionary)"
        }
    }
}
