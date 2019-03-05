import Foundation

struct XcodeProjChecksumHolder<C: Checksum>: ChecksumHolder {
    let proj: ProjChecksumHolder<C>
    let description: String
    let checksum: C
}

extension XcodeProjChecksumHolder: NodeConvertable {
    
    func node() -> TreeNode {
        return TreeNode(
            name: description,
            value: checksum.description,
            children: [proj.node()]
        )
    }
    
}
