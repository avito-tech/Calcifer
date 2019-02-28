import Foundation

public protocol URLChecksumProducer {
    associatedtype C: Checksum
    func checksum(for fileURL: URL) throws -> C
}
