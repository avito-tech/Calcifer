import Foundation
import BuildProductCacheStorage

public protocol CacheStorageFactory {
    
    func createMixedCacheStorage(
        localCacheDirectoryPath: String,
        gradleHost: String,
        shouldUpload: Bool
    ) throws -> BuildProductCacheStorage
    
    func createLocalBuildProductCacheStorage(localCacheDirectoryPath: String)
        -> BuildProductCacheStorage
    
    func createRemoteBuildProductCacheStorage(gradleHost: String) throws -> BuildProductCacheStorage
}
