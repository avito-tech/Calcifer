import Foundation
import Checksum

struct TargetInfoProviderCache<ChecksumType: Checksum> {
    let targetInfoProvider: TargetInfoProvider<ChecksumType>
    let checksum: ChecksumType
    let projectPath: String
}
