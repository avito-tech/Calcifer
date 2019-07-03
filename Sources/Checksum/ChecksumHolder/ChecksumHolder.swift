import Foundation

public protocol ChecksumHolder: class {
    associatedtype ChecksumType: Checksum
    func obtainChecksum<ChecksumProducer: URLChecksumProducer>(
        checksumProducer: ChecksumProducer
    ) throws -> ChecksumType
    where ChecksumProducer.ChecksumType == ChecksumType
}
