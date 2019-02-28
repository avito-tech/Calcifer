import Foundation

struct ProjChecksumHolder<C: Checksum>: ChecksumHolder {
    let projects: [ProjectChecksumHolder<C>]
    let objectDescription = "PBXProj"
    let checksum: C
}

