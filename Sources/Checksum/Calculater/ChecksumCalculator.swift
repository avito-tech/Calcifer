import Foundation

public protocol ChecksumCalculator {
    func calculate<ChecksumType: Checksum>(
        rootHolder: BaseChecksumHolder<ChecksumType>)
        throws -> ChecksumType
}
