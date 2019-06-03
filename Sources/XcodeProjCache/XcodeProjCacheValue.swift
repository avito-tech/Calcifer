import Foundation
import Checksum
import XcodeProj

struct XcodeProjCacheValue<ChecksumType: Checksum> {
    let xcodeProj: XcodeProj
    let checksum: ChecksumType
    let modificationDate: Date
}
