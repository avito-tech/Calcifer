import Foundation
import Checksum

public enum BuildProductCacheResult<ChecksumType: Checksum> {
    case result(_ value: BuildProductCacheValue<ChecksumType>)
    case notExist
}
