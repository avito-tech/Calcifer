import Foundation

final class Node: Equatable, CustomStringConvertible {
    
    public let name: String
    public let value: String
    public let children: [Node]?
    
    init(name: String, value: String, children: [Node]?) {
        self.name = name
        self.value = value
        self.children = children
    }
    
    static func == (lhs: Node, rhs: Node) -> Bool {
        return lhs.name == rhs.name && lhs.value == rhs.value && lhs.children == rhs.children
    }
    
    var description: String {
        return "\(name) \(value)"
    }
    
}
