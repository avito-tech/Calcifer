import Foundation

struct TargetChecksumHolder<C: Checksum>: ChecksumHolder {
    let files: [FileChecksumHolder<C>]
    let dependencies: [TargetChecksumHolder<C>]
    let objectDescription: String
    let checksum: C
}
