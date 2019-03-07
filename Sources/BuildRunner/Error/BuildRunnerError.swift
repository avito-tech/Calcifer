import Foundation

public enum BuildRunnerError: Error, CustomStringConvertible {
    case unableToParseArchitecture(string: String)
    case unableToParsePlatform(string: String)
    
    public var description: String {
        switch self {
        case let .unableToParseArchitecture(string):
            return "Unable to parse architecture from \(string)"
        case let .unableToParsePlatform(string):
            return "Unable to parse sdk name from \(string)"
        }
    }
}
