import Foundation

struct ProjectChecksumHolder<C: Checksum>: ChecksumHolder {
    let targets: [TargetChecksumHolder<C>]
    let description: String
    let checksum: C
}
