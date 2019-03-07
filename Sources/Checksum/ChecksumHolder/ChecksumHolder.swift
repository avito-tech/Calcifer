import Foundation

public protocol ChecksumHolder: Hashable, CustomStringConvertible, Codable {
    associatedtype ChecksumType: Checksum
    var checksum: ChecksumType { get }
}
