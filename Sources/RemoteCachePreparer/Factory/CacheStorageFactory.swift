import Foundation
import XcodeProjectChecksumCalculator
import BuildProductCacheStorage
import Checksum
import Toolkit

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

public final class CacheStorageFactoryImpl: CacheStorageFactory {
    
    private let fileManager: FileManager
    private let unzip: Unzip
    
    public init(
        fileManager: FileManager,
        unzip: Unzip)
    {
        self.fileManager = fileManager
        self.unzip = unzip
    }
    
    public func createMixedCacheStorage(
        localCacheDirectoryPath: String,
        gradleHost: String,
        shouldUpload: Bool)
        throws -> BuildProductCacheStorage
    {
        let localStorage = createLocalBuildProductCacheStorage(
            localCacheDirectoryPath: localCacheDirectoryPath
        )
        let remoteStorage = try createRemoteBuildProductCacheStorage(
            gradleHost: gradleHost
        )
        return MixedBuildProductCacheStorage(
            fileManager: fileManager,
            localCacheStorage: localStorage,
            remoteCacheStorage: remoteStorage,
            shouldUpload: shouldUpload
        )
    }
    
    public func createLocalBuildProductCacheStorage(localCacheDirectoryPath: String)
        -> BuildProductCacheStorage
    {
        let localStorage = LocalBuildProductCacheStorage(
            fileManager: fileManager,
            cacheDirectoryPath: localCacheDirectoryPath
        )
        return localStorage
    }
    
    public func createRemoteBuildProductCacheStorage(gradleHost: String)
        throws -> BuildProductCacheStorage
    {
        guard let gradleHostURL = URL(string: gradleHost) else {
            throw RemoteCachePreparerError.unableToCreateRemoteCacheHostURL(
                string: gradleHost
            )
        }
        let gradleClient = GradleBuildCacheClientImpl(
            gradleHost: gradleHostURL,
            session: URLSession.shared
        )
        let remoteStorage = GradleRemoteBuildProductCacheStorage(
            gradleBuildCacheClient: gradleClient,
            unzip: unzip,
            fileManager: fileManager
        )
        return remoteStorage
    }
}
