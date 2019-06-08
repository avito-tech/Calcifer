import Foundation

public struct CalciferConfig: Codable, Equatable {
    public let enabled: Bool
    public let statisticLoggerConfig: StatisticLoggerConfig?
    public let buildConfig: XcodeBuildConfig?
    public let storageConfig: CacheStorageConfig
    public let calciferUpdateConfig: CalciferUpdateConfig?
    public let calciferShipConfig: CalciferShipConfig?
    
    static func defaultConfig(calciferDirectory: String) -> CalciferConfig {
        let storageConfig = CacheStorageConfig.defaultConfig(
            calciferDirectory: calciferDirectory
        )
        return CalciferConfig(
            enabled: true,
            statisticLoggerConfig: nil,
            buildConfig: nil,
            storageConfig: storageConfig,
            calciferUpdateConfig: nil,
            calciferShipConfig: nil
        )
    }
}
