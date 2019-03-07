import Foundation
import Checksum

struct XcodeProjChecksumHolder<C: Checksum>: ChecksumHolder {
    let proj: ProjChecksumHolder<C>
    let description: String
    let checksum: C
}

extension XcodeProjChecksumHolder: NodeConvertable {
    
    func node() -> TreeNode<C> {
        return TreeNode(
            name: description,
            value: checksum,
            children: [proj.node()]
        )
    }
    
}
