import Foundation
import BuildProductCacheStorage
import RemoteCachePreparer

public final class CacheStorageFactoryStub: CacheStorageFactory {
    
    private let localBuildProductCacheStorage: BuildProductCacheStorage
    private let remoteBuildProductCacheStorage: BuildProductCacheStorage
    private let mixedCacheStorage: BuildProductCacheStorage
    
    public init(
        localBuildProductCacheStorage: BuildProductCacheStorage,
        remoteBuildProductCacheStorage: BuildProductCacheStorage,
        mixedCacheStorage: BuildProductCacheStorage)
    {
        self.localBuildProductCacheStorage = localBuildProductCacheStorage
        self.remoteBuildProductCacheStorage = remoteBuildProductCacheStorage
        self.mixedCacheStorage = mixedCacheStorage
    }
    
    public func createMixedCacheStorage(
        localCacheDirectoryPath: String,
        gradleHost: String,
        shouldUpload: Bool)
        throws -> BuildProductCacheStorage
    {
        return mixedCacheStorage
    }
    
    public func createLocalBuildProductCacheStorage(
        localCacheDirectoryPath: String)
        -> BuildProductCacheStorage
    {
        return localBuildProductCacheStorage
    }
    
    public func createRemoteBuildProductCacheStorage(
        gradleHost: String)
        throws -> BuildProductCacheStorage
    {
        return remoteBuildProductCacheStorage
    }
    
}
