import Foundation

extension Array where Element: Checksummable {
    func checksum() throws -> String {
        guard let checksum = try map({ $0.checksum }).joined().md5() else {
            throw ProjectChecksumCalculatorError.emptyChecksum
        }
        return checksum
    }
}
