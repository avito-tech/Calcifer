import Foundation
import XcodeProjectChecksumCalculator
import BuildProductCacheStorage
import Checksum
import Toolkit

public protocol CacheStorageFactory {
    
    func createMixedCacheStorage(shouldUploadCache: Bool) throws -> BuildProductCacheStorage
    
    func createLocalBuildProductCacheStorage()
        -> BuildProductCacheStorage
    
    func createRemoteBuildProductCacheStorage() throws -> BuildProductCacheStorage
}

public final class CacheStorageFactoryImpl: CacheStorageFactory {
    
    private let fileManager: FileManager
    private let unzip: Unzip
    
    init(fileManager: FileManager, unzip: Unzip) {
        self.fileManager = fileManager
        self.unzip = unzip
    }
    
    public func createMixedCacheStorage(shouldUploadCache: Bool)
        throws -> BuildProductCacheStorage
    {
        let localStorage = createLocalBuildProductCacheStorage()
        let remoteStorage = try createRemoteBuildProductCacheStorage()
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
    
    public func createRemoteBuildProductCacheStorage()
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
            unzip: unzip,
            fileManager: fileManager
        )
        return remoteStorage
    }
}
