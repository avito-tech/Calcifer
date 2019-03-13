import Foundation
import Checksum

public final class LocalCacheStorage<ChecksumType: Checksum>: CacheStorage {
    
    private let fileManager: FileManager
    
    public init(fileManager: FileManager) {
        self.fileManager = fileManager
    }
    
    // MARK: - CacheStorage
    public func cache(for entry: CacheEntry<ChecksumType>) throws -> CacheValue<ChecksumType>? {
        let entryURL = url(to: entry)
        if fileManager.directoryExist(at: entryURL) {
            return CacheValue(entry: entry, path: entryURL.path)
        }
        return nil
    }
    
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
        try fileManager.removeItem(atPath: cacheDirectoryPath())
    }
    
    private func createCacheDirectory() throws {
        try fileManager.createDirectory(
            atPath: cacheDirectoryPath(),
            withIntermediateDirectories: true
        )
    }
    
    private func cacheDirectoryPath() -> String {
        return fileManager.calciferDirectory().appendingPathComponent("localCache")
    }
    
    private func url(to entry: CacheEntry<ChecksumType>) -> URL {
        return URL(fileURLWithPath: path(to: entry))
    }
    
    private func path(to entry: CacheEntry<ChecksumType>) -> String {
        return cacheDirectoryPath()
            .appendingPathComponent(entry.name)
            .appendingPathComponent(entry.checksum.description)
    }
    
}
