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
        for cacheKey: BuildProductCacheKey<ChecksumType>,
        completion: @escaping (BuildProductCacheResult<ChecksumType>) -> ())
    {
        localCacheStorage.cached(for: cacheKey) { [weak self] result in
            switch result {
            case let .result(value):
                Logger.verbose("Cache exist in local cache for \(cacheKey.productName) \(cacheKey.productType) - \(cacheKey.checksum.stringValue)")
                completion(.result(value))
                break
            case .notExist:
                self?.obtainFromRemoteCache(
                    cacheKey: cacheKey,
                    completion: completion
                )
                break
            }
        }
    }
    
    public func add(
        cacheKey: BuildProductCacheKey<ChecksumType>,
        at path: String,
        completion: @escaping () -> ())
    {
        localCacheStorage.add(cacheKey: cacheKey, at: path) { [weak self] in
            if let shouldUpload = self?.shouldUpload,
                shouldUpload == false
            {
                completion()
                return
            }
            self?.localCacheStorage.cached(for: cacheKey) { result in
                switch result {
                case let .result(value):
                    self?.remoteCacheStorage.add(
                        cacheKey: cacheKey,
                        at: value.path,
                        completion: completion
                    )
                    break
                case .notExist:
                    completion()
                    break
                }
            }
        }
    }
    
    private func obtainFromRemoteCache(
        cacheKey: BuildProductCacheKey<ChecksumType>,
        completion: @escaping (BuildProductCacheResult<ChecksumType>) -> ())
    {
        remoteCacheStorage.cached(for: cacheKey) { [weak self] result in
            switch result {
            case let .result(value):
                Logger.verbose("Cache exist in remote cache for \(cacheKey.productName) \(cacheKey.productType) - \(cacheKey.checksum.stringValue)")
                self?.localCacheStorage.add(cacheKey: cacheKey, at: value.path) {
                    catchError {
                        try self?.fileManager.removeItem(atPath: value.path)
                    }
                    self?.localCacheStorage.cached(for: cacheKey) { localResult in
                        completion(localResult)
                    }
                }
                break
            case .notExist:
                Logger.verbose("Cache doesn't exist for \(cacheKey.productName) \(cacheKey.productType) - \(cacheKey.checksum.stringValue)")
                completion(result)
                break
            }
        }
    }
    
}
