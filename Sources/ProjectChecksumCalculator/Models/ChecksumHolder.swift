import Foundation

protocol ChecksumHolder: Hashable, CustomStringConvertible {
    associatedtype ChecksumType: Checksum
    var checksum: ChecksumType { get }
}
