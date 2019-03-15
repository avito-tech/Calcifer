import Foundation
import Checksum

public final class LocalFrameworkCacheStorage<ChecksumType: Checksum>: FrameworkCacheStorage {
    
    private let fileManager: FileManager
    private let cacheDirectoryPath: String
    
    public init(fileManager: FileManager, cacheDirectoryPath: String) {
        self.fileManager = fileManager
        self.cacheDirectoryPath = cacheDirectoryPath
    }
    
    // MARK: - FrameworkCacheStorage
    public func cached(for cacheKey: FrameworkCacheKey<ChecksumType>) throws -> FrameworkCacheValue<ChecksumType>? {
        let entryURL = url(to: cacheKey)
        if fileManager.directoryExist(at: entryURL) {
            return FrameworkCacheValue(key: cacheKey, path: entryURL.path)
        }
        return nil
    }
    
    public func add(cacheKey: FrameworkCacheKey<ChecksumType>, at artifactPath: String) throws {
        let artifactURL = URL(fileURLWithPath: artifactPath)
        let entryURL = url(to: cacheKey)
        if fileManager.directoryExist(at: entryURL) {
            try fileManager.removeItem(at: entryURL)
        }
        let entryFolderURL = entryURL.deletingLastPathComponent()
        try fileManager.createDirectory(at: entryFolderURL, withIntermediateDirectories: true)
        try fileManager.copyItem(at: artifactURL, to: entryURL)
    }
    
    @inline(__always) private func url(to cacheKey: FrameworkCacheKey<ChecksumType>) -> URL {
        return URL(fileURLWithPath: path(to: cacheKey))
    }
    
    private func path(to cacheKey: FrameworkCacheKey<ChecksumType>) -> String {
        return cacheDirectoryPath
            .appendingPathComponent(cacheKey.frameworkName)
            .appendingPathComponent(cacheKey.checksum.stringValue)
    }
    
}
