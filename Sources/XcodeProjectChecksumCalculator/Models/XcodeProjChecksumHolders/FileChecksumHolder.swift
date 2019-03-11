import Foundation
import Checksum

struct FileChecksumHolder<C: Checksum>: ChecksumHolder {
    let description: String
    let checksum: C
}

extension FileChecksumHolder: TreeNodeConvertable {
    
    func node() -> TreeNode<C> {
        let children = [TreeNode<C>]()
        return TreeNode<C>(
            name: description,
            value: checksum,
            children: children
        )
    }
    
}
