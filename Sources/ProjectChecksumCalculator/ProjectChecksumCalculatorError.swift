import Foundation

public enum ProjectChecksumCalculatorError: Error, CustomStringConvertible {
    case unableEncodeDataFromString(string: String)
    case emptyFullFilePath(name: String?, path: String?)
    case emptyRootGroup
    case emptyChecksum
    
    public var description: String {
        switch self {
        case .unableEncodeDataFromString(let string):
            return "Unable to encode data from string \(string)"
        case .emptyFullFilePath(let name, let path):
            return "Unable to obtain full file path for \(name ?? "(nil)"): \(path ?? "(nil)")"
        case .emptyRootGroup:
            return "Unable to obtain root group"
        case .emptyChecksum:
            return "Unable calculate checksum"
        }
    }
}
