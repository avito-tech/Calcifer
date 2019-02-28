import Foundation

struct XcodeProjChecksumHolder<C: Checksum>: ChecksumHolder {
    let proj: ProjChecksumHolder<C>
    let objectDescription: String
    let checksum: C
}
