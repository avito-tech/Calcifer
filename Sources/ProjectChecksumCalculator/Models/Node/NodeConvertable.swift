import Foundation

protocol NodeConvertable {
    associatedtype Value: Checksum
    func node() -> TreeNode<Value>
}

extension Array where Element: NodeConvertable {
    
    func nodeList<Value: Checksum>() -> [TreeNode<Value>]  where Element.Value == Value  {
        return map({ $0.node() })
    }
    
}
