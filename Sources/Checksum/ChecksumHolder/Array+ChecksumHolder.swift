import Foundation

public extension Array where Element: ChecksumHolder {
    
    func obtainChecksum<ChecksumType, ChecksumProducer: URLChecksumProducer>(
        checksumProducer: ChecksumProducer
        )
        throws -> ChecksumType
        where Element.ChecksumType == ChecksumType, ChecksumProducer.ChecksumType == ChecksumType
    {
        return try compactMap({ try $0.obtainChecksum(checksumProducer: checksumProducer) }).aggregate()
    }
    
}

public extension Array where Element: Checksum {
    func aggregate() throws -> Element {
        return try reduce(Element.zero, +)
    }
}
