import Foundation
import Checksum
import xcodeproj

struct XcodeProjCacheValue<ChecksumType: Checksum> {
    let xcodeProj: XcodeProj
    let checksum: ChecksumType
    let modificationDate: Date
}
