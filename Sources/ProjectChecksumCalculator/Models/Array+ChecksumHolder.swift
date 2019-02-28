import Foundation

extension Array where Element: ChecksumHolder {
    func checksum<T: Checksum>() throws -> T where Element.ChecksumType == T {
        guard let checksum: T = try compactMap({ $0.checksum }).aggregate() else {
            throw ProjectChecksumError.emptyChecksum
        }
        return checksum
    }
}

extension Array where Element: Checksum {
    func aggregate() throws -> Element? {
        return try reduce(Element.zero, +)
    }
}
