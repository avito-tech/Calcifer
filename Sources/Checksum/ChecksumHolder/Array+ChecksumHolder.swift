import Foundation

public extension Array where Element: ChecksumHolder {
    public func checksum<T: Checksum>() throws -> T where Element.ChecksumType == T {
        return try compactMap({ $0.checksum }).aggregate()
    }
}

public extension Array where Element: Checksum {
    public func aggregate() throws -> Element {
        return try reduce(Element.zero, +)
    }
}
