import Foundation

protocol NodeConvertable {
    func node() -> TreeNode
}

extension Array where Element: NodeConvertable {
    
    func nodeList() -> [TreeNode] {
        return map({ $0.node() })
    }
    
}
