import Foundation

struct ProjectChecksumHolder<C: Checksum>: ChecksumHolder {
    let targets: [TargetChecksumHolder<C>]
    let description: String
    let checksum: C
}

extension ProjectChecksumHolder: NodeConvertable {
    
    func node() -> TreeNode<C> {
        return TreeNode<C>(
            name: description,
            value: checksum,
            children: targets.nodeList()
        )
    }
    
}
