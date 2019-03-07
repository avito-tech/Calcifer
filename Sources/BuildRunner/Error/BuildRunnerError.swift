import Foundation

public enum BuildRunnerError: Error, CustomStringConvertible {
    case unableParseArchitecture(string: String)
    case unableParsePlatform(string: String)
    
    public var description: String {
        switch self {
        case let .unableParseArchitecture(string):
            return "Unable parse architecture from \(string)"
        case let .unableParsePlatform(string):
            return "Unable parse sdk name from \(string)"
        }
    }
}
