import Foundation
import Checksum

struct FileChecksumHolder<C: Checksum>: ChecksumHolder {
    let description: String
    let checksum: C
}

extension FileChecksumHolder: NodeConvertable {
    
    func node() -> TreeNode<C> {
        let children = [TreeNode<C>]()
        return TreeNode<C>(
            name: description,
            value: checksum,
            children: children
        )
    }
    
}
