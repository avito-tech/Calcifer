import Foundation

public struct CalciferConfig: Codable {
    public let statisticLoggerConfig: StatisticLoggerConfig?
    public let buildConfig: XcodeBuildConfig?
    public let storageConfig: CacheStorageConfig?
}
