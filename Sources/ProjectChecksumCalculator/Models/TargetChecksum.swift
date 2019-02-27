import Foundation

struct TargetChecksum: Checksummable {
    let files: [FileChecksum]
    let checksum: String
}
