import Foundation

struct TargetChecksumHolder<C: Checksum>: ChecksumHolder {
    let files: [FileChecksumHolder<C>]
    let objectDescription: String
    let checksum: C
}
