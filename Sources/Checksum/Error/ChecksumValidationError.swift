import Foundation

public enum ChecksumValidationError: Error, CustomStringConvertible {
    case checksumMismatch(name: String, currentChecksum: String, childrenChecksum: String)
    case duplicateChecksumHolder(name: String)
    case notCalculatedChecksum(name: String)
    
    public var description: String {
        switch self {
        case let .checksumMismatch(name, currentChecksum, childrenChecksum):
            return "Checksum for \(name) mismatch current \(currentChecksum) children checksum \(childrenChecksum)"
        case let .duplicateChecksumHolder(name):
            return "Duplicate checksum holder for \(name)"
        case let .notCalculatedChecksum(name):
            return "Checksum for \(name) not calculated"
        }
    }
}
