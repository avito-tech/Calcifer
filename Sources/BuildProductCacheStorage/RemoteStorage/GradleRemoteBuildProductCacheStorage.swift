import Foundation
import Checksum
import ZIPFoundation

public final class GradleRemoteBuildProductCacheStorage<ChecksumType: Checksum>: BuildProductCacheStorage {
    
    private let gradleBuildCacheClient: GradleBuildCacheClient
    private let fileManager: FileManager
    
    public init(
        gradleBuildCacheClient: GradleBuildCacheClient,
        fileManager: FileManager)
    {
        self.gradleBuildCacheClient = gradleBuildCacheClient
        self.fileManager = fileManager
    }
    
    // MARK: - FrameworkCacheStorage
    public func cached(
        for cacheKey: BuildProductCacheKey<ChecksumType>)
        throws -> BuildProductCacheValue<ChecksumType>?
    {
        let semaphore = DispatchSemaphore(value: 0)
        let key = try gradleKey(for: cacheKey)
        var downloadResult: BuildCacheClientResult<URL>?
        gradleBuildCacheClient.download(key: key) { result in
            downloadResult = result
            semaphore.signal()
        }
        semaphore.wait()
        guard let result = downloadResult else {
            throw BuildProductCacheStorageError.unableToDownloadCache(key: key)
        }
        switch result {
        case let .success(url):
            let unzipURL = url.deletingLastPathComponent()
            try fileManager.unzipItem(at: url, to: unzipURL)
            let unzipResult = unzipURL.appendingPathComponent(cacheKey.checksum.stringValue)
            try fileManager.removeItem(at: url)
            var path = unzipResult.path.appendingPathComponent(cacheKey.productName)
            path.append(cacheKey.productType.fileExtension)
            try validateArtifactExist(at: path)
            return BuildProductCacheValue(key: cacheKey, path: path)
        case let .failure(error):
            throw BuildProductCacheStorageError.networkError(error: error)
        }
    }
    
    public func add(cacheKey: BuildProductCacheKey<ChecksumType>, at artifactPath: String) throws {
        let artifactURL = URL(fileURLWithPath: artifactPath)
        let key = try gradleKey(for: cacheKey)
        let zipFileURL = URL(
            fileURLWithPath: artifactPath.deletingLastPathComponent()
        ).appendingPathComponent(key + ".zip")
        try fileManager.zipItem(at: artifactURL, to: zipFileURL)
        let semaphore = DispatchSemaphore(value: 0)
        gradleBuildCacheClient.upload(fileURL: zipFileURL, key: key) { result in
            semaphore.signal()
        }
        semaphore.wait()
        try fileManager.removeItem(at: zipFileURL)
    }
    
    private func validateArtifactExist(at path: String) throws {
        if fileManager.fileExists(atPath: path) == false {
            throw BuildProductCacheStorageError.unableToCreateGradleCacheKey
        }
    }
    
    func gradleKey(for cacheKey: BuildProductCacheKey<ChecksumType>) throws -> String {
        guard let key = try (
            cacheKey.productType.rawValue + "-" +
            cacheKey.productName + "-" +
            cacheKey.checksum.stringValue
            ).md5()
        else {
            throw BuildProductCacheStorageError.unableToCreateGradleCacheKey
        }
        return key
    }
    
}
