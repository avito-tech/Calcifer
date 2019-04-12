import Foundation
import Checksum
import Toolkit

public final class MixedBuildProductCacheStorage<
    ChecksumType,
    LocalCacheStorage: BuildProductCacheStorage,
    RemoteCacheStorage: BuildProductCacheStorage>: BuildProductCacheStorage
    where
    LocalCacheStorage.ChecksumType == ChecksumType,
    RemoteCacheStorage.ChecksumType == ChecksumType
{
    
    private let fileManager: FileManager
    private let localCacheStorage: LocalCacheStorage
    private let remoteCacheStorage: RemoteCacheStorage
    private let shouldUpload: Bool
    
    public init(
        fileManager: FileManager,
        localCacheStorage: LocalCacheStorage,
        remoteCacheStorage: RemoteCacheStorage,
        shouldUpload: Bool)
    {
        self.fileManager = fileManager
        self.localCacheStorage = localCacheStorage
        self.remoteCacheStorage = remoteCacheStorage
        self.shouldUpload = shouldUpload
    }
    
    // MARK: - FrameworkCacheStorage
    public func cached(
        for cacheKey: BuildProductCacheKey<ChecksumType>)
        throws -> BuildProductCacheValue<ChecksumType>?
    {
        if let localCacheValue = try localCacheStorage.cached(for: cacheKey) {
            Logger.verbose("Cache exist in local cache for \(cacheKey.productName) \(cacheKey.productType) - \(cacheKey.checksum.stringValue)")
            return localCacheValue
        } else {
            guard let cacheValue = try? remoteCacheStorage.cached(for: cacheKey),
                let remoteCacheValue = cacheValue
                else {
                    Logger.verbose("Cache doesn't exist for \(cacheKey.productName) \(cacheKey.productType) - \(cacheKey.checksum.stringValue)")
                    return nil
                }
            try localCacheStorage.add(cacheKey: cacheKey, at: remoteCacheValue.path)
            try fileManager.removeItem(atPath: remoteCacheValue.path)
            Logger.verbose("Cache exist in remote cache for \(cacheKey.productName) \(cacheKey.productType) - \(cacheKey.checksum.stringValue)")
            return try localCacheStorage.cached(for: cacheKey)
        }
    }
    
    public func add(
        cacheKey: BuildProductCacheKey<ChecksumType>,
        at artifactPath: String) throws
    {
        try localCacheStorage.add(cacheKey: cacheKey, at: artifactPath)
        if shouldUpload == true,
            let localCacheValue = try localCacheStorage.cached(for: cacheKey)
        {
            try remoteCacheStorage.add(
                cacheKey: cacheKey,
                at: localCacheValue.path
            )
        }
    }
    
}
