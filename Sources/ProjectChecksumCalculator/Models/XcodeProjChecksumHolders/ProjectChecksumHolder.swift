import Foundation

struct ProjectChecksumHolder<C: Checksum>: ChecksumHolder {
    let targets: [TargetChecksumHolder<C>]
    let description: String
    let checksum: C
}

extension ProjectChecksumHolder: NodeConvertable {
    
    func node() -> TreeNode {
        return TreeNode(
            name: description,
            value: checksum.description,
            children: targets.nodeList()
        )
    }
    
}
