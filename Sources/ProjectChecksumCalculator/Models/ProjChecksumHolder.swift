import Foundation

struct ProjChecksumHolder<C: Checksum>: ChecksumHolder {
    let projects: [ProjectChecksumHolder<C>]
    let description = "PBXProj"
    let checksum: C
}

