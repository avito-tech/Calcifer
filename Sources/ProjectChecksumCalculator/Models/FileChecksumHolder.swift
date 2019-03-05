import Foundation

struct FileChecksumHolder<C: Checksum>: ChecksumHolder {
    let description: String
    let checksum: C
}

extension FileChecksumHolder: NodeConvertable {
    
    func node() -> Node {
        return Node(
            name: description,
            value: checksum.description,
            children: nil
        )
    }
    
}
