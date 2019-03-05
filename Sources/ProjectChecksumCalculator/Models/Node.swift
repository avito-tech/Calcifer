import Foundation

class Node: Equatable, CustomStringConvertible {
    
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

protocol NodeConvertable {
    func node() -> Node
}

extension Array where Element: NodeConvertable {
    
    func nodeList() -> [Node] {
        return map({ $0.node() })
    }
    
}

public struct Diff {
    let was: Node?
    let became: Node?
    let children: [Diff]?
    
    init(was: Node?, became: Node?, children: [Diff]?) {
        self.was = was
        self.became = became
        self.children = children
    }
    
    func printTree(level: Int = 0) {
        let offset = String(repeating: " ", count: level)
        print("\(offset)was: \(was?.description ?? "-") became: \(became?.description ?? "-")")
        
        if let children = children {
            for child in children {
                child.printTree(level: level + 4)
            }
        }
    }
    
}

extension Node {
    func diff(became: Node?) -> Diff? {
        if self == became {
            return nil
        }
        var allChildren = [String]()
        let wasChildren = Dictionary(uniqueKeysWithValues:
            children?.compactMap({ ($0.name, $0) }) ?? []
        )
        wasChildren.keys.forEach {
            if !allChildren.contains($0) {
                allChildren.append($0)
            }
        }
        var becameChildren = [String : Node]()
        if let became = became {
            becameChildren = Dictionary(uniqueKeysWithValues:
                became.children?.compactMap({ ($0.name, $0) }) ?? []
            )
        }
        becameChildren.keys.forEach {
            if !allChildren.contains($0) {
                allChildren.append($0)
            }
        }
        let childrenDiff = allChildren.compactMap({
            wasChildren[$0]?.diff(became: becameChildren[$0])
        })
        return Diff(was: self, became: became, children: childrenDiff)
    }
}
