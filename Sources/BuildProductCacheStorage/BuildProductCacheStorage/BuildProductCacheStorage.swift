import Foundation
import Checksum

public protocol BuildProductCacheStorage {
    
    associatedtype ChecksumType: Checksum
    
    func cached(
        for cacheKey: BuildProductCacheKey<ChecksumType>,
        completion: @escaping (BuildProductCacheResult<ChecksumType>) -> ()
    )
    
    func add(
        cacheKey: BuildProductCacheKey<ChecksumType>,
        at path: String,
        completion: @escaping () -> ()
    )
    
}
