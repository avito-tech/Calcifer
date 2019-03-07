import Foundation

public protocol TreeNodeConvertable {
    associatedtype Value: Checksum
    func node() -> TreeNode<Value>
}

public extension Array where Element: TreeNodeConvertable {
    
    public func nodeList<Value: Checksum>() -> [TreeNode<Value>]  where Element.Value == Value  {
        return map({ $0.node() })
    }
    
}
