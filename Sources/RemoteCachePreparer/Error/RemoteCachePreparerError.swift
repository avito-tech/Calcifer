import Foundation

public enum RemoteCachePreparerError: Error, CustomStringConvertible {
    case unableToParseArchitecture(string: String)
    case unableToParsePlatform(string: String)
    case unableToObtainCache(target: String, checksumValue: String)
    case unableToCreateRemoteCacheHostURL(string: String)
    
    public var description: String {
        switch self {
        case let .unableToParseArchitecture(string):
            return "Unable to parse architecture from \(string)"
        case let .unableToParsePlatform(string):
            return "Unable to parse sdk name from \(string)"
        case let .unableToObtainCache(target, checksumValue):
            return "Unable to obtain local cache for target \(target) with checksum \(checksumValue)"
        case let .unableToCreateRemoteCacheHostURL(string):
            return "Unable to create remote cache host URL from \(string)"
        }
    }
}
