import Foundation

public enum XcodeProjectChecksumCalculatorError: Error, CustomStringConvertible {
    case unableToEncodeDataFromString(string: String)
    case emptyFullFilePath(name: String?, path: String?)
    case emptyRootGroup
    case emptyChecksum
    case emptyProductName(target: String)
    case emptyProductType(target: String)
    case emptyProductChecksum(productName: String)
    case emptyTargetChecksum(targetName: String)
    case unableToObtainSourceRoot(projectPath: String)
    
    public var description: String {
        switch self {
        case let .unableToEncodeDataFromString(string):
            return "Unable to encode data from string \(string)"
        case let .emptyFullFilePath(name, path):
            return "Unable to obtain full file path for \(name ?? "(nil)"): \(path ?? "(nil)")"
        case .emptyRootGroup:
            return "Unable to obtain root group"
        case .emptyChecksum:
            return "Unable to calculate checksum"
        case let .emptyProductName(target):
            return "Empty product name for target: \(target)"
        case let .emptyProductType(target):
            return "Empty product type for target: \(target)"
        case let .emptyProductChecksum(productName):
            return "Empty checksum for productName \(productName)"
        case let .emptyTargetChecksum(targetName):
            return "Empty checksum for targetName \(targetName)"
        case let .unableToObtainSourceRoot(projectPath):
            return "Unable to obtain source root for project path \(projectPath)"
        }
    }
}
