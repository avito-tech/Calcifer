import Foundation

public struct CalciferConfig: Codable {
    public let enabled: Bool?
    public let statisticLoggerConfig: StatisticLoggerConfig?
    public let buildConfig: XcodeBuildConfig?
    public let storageConfig: CacheStorageConfig?
    public let calciferUpdateConfig: CalciferUpdateConfig?
    public let calciferShipConfig: CalciferShipConfig?
}
