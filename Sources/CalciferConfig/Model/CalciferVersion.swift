import Foundation

public struct CalciferVersion: Codable {
    public let checksum: String
    
    public init(checksum: String) {
        self.checksum = checksum
    }
}
