import Foundation
import Checksum

public final class LocalCacheStorage<ChecksumType: Checksum>: CacheStorage {
    
    private let fileManager: FileManager
    private let cacheDirectoryPath: String
    
    public init(fileManager: FileManager, cacheDirectoryPath: String) {
        self.fileManager = fileManager
        self.cacheDirectoryPath = cacheDirectoryPath
    }
    
    // MARK: - CacheStorage
    public func cache(for cacheKey: CacheKey<ChecksumType>) throws -> CacheValue<ChecksumType>? {
        let entryURL = url(to: cacheKey)
        if fileManager.directoryExist(at: entryURL) {
            return CacheValue(key: cacheKey, path: entryURL.path)
        }
        return nil
    }
    
    @discardableResult
    public func add(cacheKey: CacheKey<ChecksumType>, at artifactPath: String) throws -> CacheValue<ChecksumType> {
        let artifactURL = URL(fileURLWithPath: artifactPath)
        let entryURL = url(to: cacheKey)
        if fileManager.directoryExist(at: entryURL) {
            try fileManager.removeItem(at: entryURL)
        }
        let entryFolderURL = entryURL.deletingLastPathComponent()
        try fileManager.createDirectory(at: entryFolderURL, withIntermediateDirectories: true)
        try fileManager.copyItem(at: artifactURL, to: entryURL)
        return CacheValue(key: cacheKey, path: entryURL.path)
    }
    
    public func purge() throws {
        try fileManager.removeItem(atPath: cacheDirectoryPath)
    }
    
    private func url(to cacheKey: CacheKey<ChecksumType>) -> URL {
        return URL(fileURLWithPath: path(to: cacheKey))
    }
    
    private func path(to cacheKey: CacheKey<ChecksumType>) -> String {
        return cacheDirectoryPath
            .appendingPathComponent(cacheKey.name)
            .appendingPathComponent(cacheKey.checksum.description)
    }
    
}
