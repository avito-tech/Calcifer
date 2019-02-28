import Foundation

protocol ChecksumHolder: Hashable {
    associatedtype ChecksumType: Checksum
    var checksum: ChecksumType { get }
    var objectDescription: String { get }
}
