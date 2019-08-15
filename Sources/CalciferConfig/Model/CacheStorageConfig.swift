import Foundation

public struct CacheStorageConfig: Codable, Equatable {
    public let gradleHost: String?
    public let localCacheDirectory: String
    public let shouldUpload: Bool
    public let maxAgeInDaysForLocalArtifact: UInt
    
    static func defaultConfig(calciferDirectory: String) -> CacheStorageConfig {
        let localCacheDirectory = calciferDirectory
            .appendingPathComponent("localCache")
        return CacheStorageConfig(
            gradleHost: nil,
            localCacheDirectory: localCacheDirectory,
            shouldUpload: false,
            maxAgeInDaysForLocalArtifact: 7
        )
    }
}
