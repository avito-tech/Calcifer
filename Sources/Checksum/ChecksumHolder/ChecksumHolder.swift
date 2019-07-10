import Foundation

public protocol ChecksumHolder: class {
    associatedtype ChecksumType: Checksum
    func obtainChecksum() throws -> ChecksumType
}
