import Foundation

protocol NodeConvertable {
    func node() -> Node
}

extension Array where Element: NodeConvertable {
    
    func nodeList() -> [Node] {
        return map({ $0.node() })
    }
    
}
