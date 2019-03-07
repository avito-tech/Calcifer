import Foundation

public enum BuildParametersParserError: Error, CustomStringConvertible {
    case emptyBuildParameter(key: String)
    
    public var description: String {
        switch self {
        case let .emptyBuildParameter(key):
            return "Parameter \(key) is empty"
        }
    }
}
