import Foundation

public protocol NodeConvertable {
    associatedtype Value: Checksum
    func node() -> TreeNode<Value>
}

public extension Array where Element: NodeConvertable {
    
    public func nodeList<Value: Checksum>() -> [TreeNode<Value>]  where Element.Value == Value  {
        return map({ $0.node() })
    }
    
}
