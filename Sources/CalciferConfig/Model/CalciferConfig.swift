import Foundation

public struct CalciferConfig: Codable, Equatable {
    // TODO: Rename to calciferIsEnabled
    public let enabled: Bool
    public let statisticLoggerConfig: StatisticLoggerConfig?
    public let buildConfig: XcodeBuildConfig
    public let storageConfig: CacheStorageConfig
    public let calciferUpdateConfig: CalciferUpdateConfig?
    public let calciferShipConfig: CalciferShipConfig?
    public let daemonConfig: DaemonConfig
    
    static func defaultConfig(calciferDirectory: String) -> CalciferConfig {
        let storageConfig = CacheStorageConfig.defaultConfig(
            calciferDirectory: calciferDirectory
        )
        let daemonConfig = DaemonConfig.defaultConfig()
        let buildConfig = XcodeBuildConfig.defaultConfig()
        return CalciferConfig(
            enabled: true,
            statisticLoggerConfig: nil,
            buildConfig: buildConfig,
            storageConfig: storageConfig,
            calciferUpdateConfig: nil,
            calciferShipConfig: nil,
            daemonConfig: daemonConfig
        )
    }
}
