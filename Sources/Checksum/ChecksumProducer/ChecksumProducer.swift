import Foundation

public protocol ChecksumProducer {
    associatedtype Input
    associatedtype C: Checksum
    func checksum(input: Input) throws -> C
}
