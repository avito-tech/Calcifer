import Foundation

struct FileChecksumHolder<C: Checksum>: ChecksumHolder {    
    let description: String
    let checksum: C
}
