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
    public func cache(for entry: CacheEntry<ChecksumType>) throws -> CacheValue<ChecksumType>? {
        let entryURL = url(to: entry)
        if fileManager.directoryExist(at: entryURL) {
            return CacheValue(entry: entry, path: entryURL.path)
        }
        return nil
    }
    
    @discardableResult
    public func add(entry: CacheEntry<ChecksumType>, at artifactPath: String) throws -> CacheValue<ChecksumType> {
        let artifactURL = URL(fileURLWithPath: artifactPath)
        let entryURL = url(to: entry)
        if fileManager.directoryExist(at: entryURL) {
            try fileManager.removeItem(at: entryURL)
        }
        let entryFolderURL = entryURL.deletingLastPathComponent()
        try fileManager.createDirectory(at: entryFolderURL, withIntermediateDirectories: true)
        try fileManager.copyItem(at: artifactURL, to: entryURL)
        return CacheValue(entry: entry, path: entryURL.path)
    }
    
    public func purge() throws {
        try fileManager.removeItem(atPath: cacheDirectoryPath)
    }
    
    private func url(to entry: CacheEntry<ChecksumType>) -> URL {
        return URL(fileURLWithPath: path(to: entry))
    }
    
    private func path(to entry: CacheEntry<ChecksumType>) -> String {
        return cacheDirectoryPath
            .appendingPathComponent(entry.name)
            .appendingPathComponent(entry.checksum.description)
    }
    
}
