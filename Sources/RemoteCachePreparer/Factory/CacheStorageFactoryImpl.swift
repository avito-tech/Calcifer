import Foundation
import XcodeProjectChecksumCalculator
import BuildProductCacheStorage
import Checksum
import Toolkit

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
        maxAgeInDaysForLocalArtifact: UInt,
        gradleHost: String,
        shouldUpload: Bool)
        throws -> BuildProductCacheStorage
    {
        let localStorage = createLocalBuildProductCacheStorage(
            localCacheDirectoryPath: localCacheDirectoryPath,
            maxAgeInDaysForLocalArtifact: maxAgeInDaysForLocalArtifact
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
    
    public func createLocalBuildProductCacheStorage(
        localCacheDirectoryPath: String,
        maxAgeInDaysForLocalArtifact: UInt)
        -> BuildProductCacheStorage
    {
        let localStorage = LocalBuildProductCacheStorage(
            fileManager: fileManager,
            cacheDirectoryPath: localCacheDirectoryPath,
            maxAgeInDaysForLocalArtifact: maxAgeInDaysForLocalArtifact
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
