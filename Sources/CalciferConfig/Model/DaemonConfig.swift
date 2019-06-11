import Foundation

public struct DaemonConfig: Codable, Equatable {
    public let host: String
    public let port: Int
    public let endpoint: String
    
    static func defaultConfig() -> DaemonConfig {
        return DaemonConfig(
            host: "ws://localhost",
            port: 9080,
            endpoint: "daemon"
        )
    }
}
