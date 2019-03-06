import Foundation

struct ProjChecksumHolder<C: Checksum>: ChecksumHolder {
    let projects: [ProjectChecksumHolder<C>]
    let description = "PBXProj"
    let checksum: C
}

extension ProjChecksumHolder: NodeConvertable {
    
    func node() -> TreeNode<C> {
        return TreeNode(
            name: description,
            value: checksum,
            children: projects.nodeList()
        )
    }
    
}
