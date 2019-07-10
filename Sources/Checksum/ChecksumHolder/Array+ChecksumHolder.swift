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
    func aggregate() throws -> Element {
        return try reduce(Element.zero, +)
    }
}
