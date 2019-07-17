import Foundation

public enum ChecksumError: Error, CustomStringConvertible {
    case fileDoesntExist(path: String)
    case zeroChecksum(path: String)
    case unableToEnumerateDirectory(path: String)
    case checksumMismatch(name: String, currentChecksum: String, childrenChecksum: String)
    case dublicateChecksumHolder(name: String)
    case notCalculatedChecksum(name: String)
    
    public var description: String {
        switch self {
        case let .fileDoesntExist(path):
            return "File doesn't exist at path \(path)"
        case let .zeroChecksum(path):
            return "Checksum for \(path) is empty"
        case let .unableToEnumerateDirectory(path):
            return "Unable to enumerate \(path)"
        case let .checksumMismatch(name, currentChecksum, childrenChecksum):
            return "Checksum for \(name) mismatch current \(currentChecksum) children checksum \(childrenChecksum)"
        case let .dublicateChecksumHolder(name):
            return "Dublicate checksum holder for \(name)"
        case let .notCalculatedChecksum(name):
            return "Checksum for \(name) not calculated"
        }
    }
}
