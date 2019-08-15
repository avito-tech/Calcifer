import Foundation
import BuildProductCacheStorage

public protocol CacheStorageFactory {
    
    func createMixedCacheStorage(
        localCacheDirectoryPath: String,
        maxAgeInDaysForLocalArtifact: UInt,
        gradleHost: String,
        shouldUpload: Bool
    ) throws -> BuildProductCacheStorage
    
    func createLocalBuildProductCacheStorage(
        localCacheDirectoryPath: String,
        maxAgeInDaysForLocalArtifact: UInt
    ) -> BuildProductCacheStorage
    
    func createRemoteBuildProductCacheStorage(gradleHost: String) throws -> BuildProductCacheStorage
}
