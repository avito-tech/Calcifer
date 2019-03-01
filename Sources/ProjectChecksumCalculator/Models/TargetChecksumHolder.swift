import Foundation

struct TargetChecksumHolder<C: Checksum>: ChecksumHolder {
    let files: [FileChecksumHolder<C>]
    let dependencies: [TargetChecksumHolder<C>]
    let description: String
    let checksum: C
}
