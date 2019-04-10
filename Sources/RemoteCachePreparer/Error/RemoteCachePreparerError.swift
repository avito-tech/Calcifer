import Foundation

public enum RemoteCachePreparerError: Error, CustomStringConvertible {
    case unableToObtainSourcePath
    case unableToParseArchitecture(string: String)
    case unableToParsePlatform(string: String)
    case unableToObtainCache(target: String, type: String, checksumValue: String)
    case unableToCreateRemoteCacheHostURL(string: String)
    case unableToFindDSYM(target: String, path: String)
    case unableToBinaryInFramework(path: String, productName: String)
    
    public var description: String {
        switch self {
        case .unableToObtainSourcePath:
            return "Unable to obtain source path"
        case let .unableToParseArchitecture(string):
            return "Unable to parse architecture from \(string)"
        case let .unableToParsePlatform(string):
            return "Unable to parse sdk name from \(string)"
        case let .unableToObtainCache(target, type, checksumValue):
            return "Unable to obtain local cache for target \(target) type \(type) with checksum \(checksumValue)"
        case let .unableToCreateRemoteCacheHostURL(string):
            return "Unable to create remote cache host URL from \(string)"
        case let .unableToFindDSYM(target, path):
            return "Unable to find dSYM for target \(target) at path \(path)"
        case let .unableToBinaryInFramework(path, productName):
            return "Unable to find binary for product \(productName) at path \(path)"
        }
    }
}
