import Foundation

protocol Checksummable: Hashable {
    var checksum: String { get }
}
