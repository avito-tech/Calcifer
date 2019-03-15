import Foundation
import Checksum
import ZIPFoundation

public final class GradleRemoteFrameworkCacheStorage<ChecksumType: Checksum>: FrameworkCacheStorage {
    
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
        for cacheKey: FrameworkCacheKey<ChecksumType>)
        throws -> FrameworkCacheValue<ChecksumType>?
    {
        let semaphore = DispatchSemaphore(value: 0)
        let key = cacheKey.checksum.stringValue
        var downloadResult: BuildCacheClientResult<URL?>?
        gradleBuildCacheClient.download(key: key) { result in
            downloadResult = result
            semaphore.signal()
        }
        semaphore.wait()
        guard let result = downloadResult else {
            throw FrameworkCacheStorageError.unableToDownloadCache(key: key)
        }
        switch result {
        case let .success(url):
            guard let url = url else {
                throw FrameworkCacheStorageError.unableToDownloadCache(key: key)
            }
            let unzipURL = url.deletingLastPathComponent()
            try fileManager.unzipItem(at: url, to: unzipURL)
            let unzipResult = unzipURL.appendingPathComponent(key)
            try fileManager.removeItem(at: url)
            return FrameworkCacheValue(key: cacheKey, path: unzipResult.path)
        case let .failure(error):
            throw FrameworkCacheStorageError.networkError(error: error)
        }
    }
    
    public func add(cacheKey: FrameworkCacheKey<ChecksumType>, at artifactPath: String) throws {
        let artifactURL = URL(fileURLWithPath: artifactPath)
        let zipFilePath = artifactPath.appending(".zip")
        let zipFileURL = URL(fileURLWithPath: zipFilePath)
        try fileManager.zipItem(at: artifactURL, to: zipFileURL)
        let semaphore = DispatchSemaphore(value: 0)
        let key = cacheKey.checksum.stringValue
        gradleBuildCacheClient.upload(fileURL: zipFileURL, key: key) { result in
            semaphore.signal()
        }
        semaphore.wait()
        try fileManager.removeItem(at: zipFileURL)
    }
    
}
