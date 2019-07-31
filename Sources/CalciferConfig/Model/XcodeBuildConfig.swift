import Foundation

public struct XcodeBuildConfig: Codable, Equatable {
    public let buildLogLevel: BuildLogLevel
    public let shouldGenerateDSYMs: Bool
    
    static func defaultConfig() -> XcodeBuildConfig {
        return XcodeBuildConfig(
            buildLogLevel: .info,
            shouldGenerateDSYMs: true
        )
    }
}
