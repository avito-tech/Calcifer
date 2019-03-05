import Foundation

final class TreeNode: Equatable, CustomStringConvertible {
    
    public let name: String
    public let value: String
    public let children: [TreeNode]?
    
    init(name: String, value: String, children: [TreeNode]?) {
        self.name = name
        self.value = value
        self.children = children
    }
    
    static func == (lhs: TreeNode, rhs: TreeNode) -> Bool {
        return lhs.name == rhs.name && lhs.value == rhs.value && lhs.children == rhs.children
    }
    
    var description: String {
        return "\(name) \(value)"
    }
    
}
