import Foundation

public protocol ChecksumProducer {
    associatedtype Input
    associatedtype ChecksumType: Checksum
    func checksum(input: Input) throws -> ChecksumType
}
