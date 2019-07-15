import Foundation
import BuildProductCacheStorage
import Checksum

public final class BuildProductCacheStorageStub: BuildProductCacheStorage {
    
    private let onCached: (String) -> (String)
    private let onAdd: (String, String) -> ()
    
    public init(
        onCached: @escaping (String) -> (String),
        onAdd: @escaping (String, String) -> () = { _, _ in })
    {
        self.onCached = onCached
        self.onAdd = onAdd
    }
    
    public func cached<ChecksumType: Checksum>(
        for cacheKey: BuildProductCacheKey<ChecksumType>,
        completion: @escaping (BuildProductCacheResult<ChecksumType>) -> ())
    {
        let value = BuildProductCacheValue(
            key: cacheKey,
            path: onCached(cacheKey.productName)
        )
        let result = BuildProductCacheResult.result(value)
        completion(result)
    }
    
    public func add<ChecksumType: Checksum>(
        cacheKey: BuildProductCacheKey<ChecksumType>,
        at path: String,
        completion: @escaping () -> ())
    {
        onAdd(cacheKey.productName, path)
        completion()
    }
    
    
}
