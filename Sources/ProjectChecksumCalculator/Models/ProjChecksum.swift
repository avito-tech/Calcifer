import Foundation

struct ProjChecksum: Checksummable {
    let projects: [ProjectChecksum]
    let checksum: String
}
