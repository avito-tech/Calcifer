import Foundation

public extension Array where Element: ChecksumHolder {
    
    func obtainChecksum<ChecksumType>()
        throws -> ChecksumType
        where Element.ChecksumType == ChecksumType
    {
        return try compactMap({ try $0.obtainChecksum() }).aggregate()
    }
    
}

public extension Array where Element: Checksum {
    struct EmptyCollectionOfChecksums: Error, CustomStringConvertible {
        public let description = "Cannot provide aggregated checksum for empty collection"
    }
    
    func aggregate() throws -> Element {
        guard !isEmpty, let first = self.first else {
            throw EmptyCollectionOfChecksums()
        }
        var result = first
        for element in dropFirst() {
            result = result.combine(other: element)
        }
        return result
    }
}
