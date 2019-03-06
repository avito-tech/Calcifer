import Foundation

final class TreeNode<Value: Checksum>: Equatable, CustomStringConvertible {
    
    public let name: String
    public let value: Value
    public let children: [TreeNode<Value>]?
    
    init(name: String, value: Value, children: [TreeNode<Value>]?) {
        self.name = name
        self.value = value
        self.children = children
    }
    
    static func == (lhs: TreeNode<Value>, rhs: TreeNode<Value>) -> Bool {
        return lhs.name == rhs.name && lhs.value == rhs.value && lhs.children == rhs.children
    }
    
    var description: String {
        return "\(name) \(value)"
    }
    
}
