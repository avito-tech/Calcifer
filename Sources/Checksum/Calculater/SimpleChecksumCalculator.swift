import Foundation

public final class SimpleChecksumCalculator: ChecksumCalculator {
    
    public init() {}
    
    public func calculate<ChecksumType: Checksum>(
        rootHolder: BaseChecksumHolder<ChecksumType>)
        throws -> ChecksumType
    {
        return try rootHolder.obtainChecksum()
    }
}
