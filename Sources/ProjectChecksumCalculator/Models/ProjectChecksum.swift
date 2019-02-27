import Foundation

struct ProjectChecksum: Checksummable {
    let targets: [TargetChecksum]
    let checksum: String
}
