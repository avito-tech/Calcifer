import Foundation

struct FileChecksumHolder<C: Checksum>: ChecksumHolder {
    let objectDescription: String
    let checksum: C
}
