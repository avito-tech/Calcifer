import Foundation

public struct CalciferVersion: Codable, Equatable {
    public let checksum: String
    
    public init(checksum: String) {
        self.checksum = checksum
    }
}
