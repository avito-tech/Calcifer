import Foundation
import XcodeProjectChecksumCalculator
import BuildProductCacheStorage
import Checksum
import Toolkit

public protocol CacheStorageFactory {
    
    func createMixedCacheStorage(shouldUploadCache: Bool) throws -> BuildProductCacheStorage
    
    func createLocalBuildProductCacheStorage()
        -> BuildProductCacheStorage
    
    func createRemoteBuildProductCacheStorage(shouldUploadCache: Bool)
        throws -> BuildProductCacheStorage
}

public final class CacheStorageFactoryImpl: CacheStorageFactory {
    
    private let fileManager: FileManager
    
    init(fileManager: FileManager) {
        self.fileManager = fileManager
    }
    
    public func createMixedCacheStorage(shouldUploadCache: Bool)
        throws -> BuildProductCacheStorage
    {
        let localStorage = createLocalBuildProductCacheStorage()
        let remoteStorage = try createRemoteBuildProductCacheStorage(
            shouldUploadCache: shouldUploadCache
        )
        return MixedBuildProductCacheStorage(
            fileManager: fileManager,
            localCacheStorage: localStorage,
            remoteCacheStorage: remoteStorage,
            shouldUpload: shouldUploadCache
        )
    }
    
    public func createLocalBuildProductCacheStorage()
        -> BuildProductCacheStorage
    {
        let localCacheDirectoryPath = fileManager.calciferDirectory()
            .appendingPathComponent("localCache")
        let localStorage = LocalBuildProductCacheStorage(
            fileManager: fileManager,
            cacheDirectoryPath: localCacheDirectoryPath
        )
        return localStorage
    }
    
    public func createRemoteBuildProductCacheStorage(shouldUploadCache: Bool)
        throws -> BuildProductCacheStorage
    {
        let gradleHost = "http://gradle-remote-cache-ios.k.avito.ru"
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
            fileManager: fileManager
        )
        return remoteStorage
    }
}
