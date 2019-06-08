import Foundation

public struct GraphiteConfig: Codable, Equatable {
    public let host: String
    public let port: Int
    public let rootKey: String
}
