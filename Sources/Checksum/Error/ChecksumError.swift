import Foundation

public enum ChecksumError: Error, CustomStringConvertible {
    case fileDoesntExist(path: String)
    case zeroChecksum(path: String)
    
    public var description: String {
        switch self {
        case let .fileDoesntExist(path):
            return "File doesn't exist at path \(path)"
        case let .zeroChecksum(path):
            return "Checksum for \(path) is empty"
        }
    }
}
