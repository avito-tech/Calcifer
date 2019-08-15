import Foundation
import Checksum

public protocol BuildProductCacheStorage {
    
    func cached<ChecksumType: Checksum>(
        for cacheKey: BuildProductCacheKey<ChecksumType>,
        completion: @escaping (BuildProductCacheResult<ChecksumType>) -> ()
    )
    
    func add<ChecksumType: Checksum>(
        cacheKey: BuildProductCacheKey<ChecksumType>,
        at path: String,
        completion: @escaping () -> ()
    )
    
    func clean(completion: @escaping () -> ())
    
}
