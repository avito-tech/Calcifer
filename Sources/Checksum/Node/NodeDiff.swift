import Foundation

public enum NodeDiff<Value: Checksum>: CustomStringConvertible {
    case noChanged
    case changed(was: TreeNode<Value>, became: TreeNode<Value>, children: [NodeDiff])
    case appear(became: TreeNode<Value>, children: [NodeDiff])
    case disappear(was: TreeNode<Value>, children: [NodeDiff])
    
    public var children: [NodeDiff] {
        switch self {
        case .noChanged:
            return [NodeDiff]()
        case let .changed(_, _, children):
            return children
        case let .appear(_, children):
            return children
        case let .disappear(_, children):
            return children
        }
    }
    
    public var description: String {
        switch self {
        case .noChanged:
            return "noChanged"
        case let .changed(was, became, _):
            return "changed was: \(was) became: \(became)"
        case let .appear(became, _):
            return "appear: \(became)"
        case let .disappear(was, _):
            return "disappear: \(was)"
        }
    }
    
    public func printTree(level: Int = 0) {
        if case .noChanged = self {
            return
        }
        let offset = String(repeating: " ", count: level)
        print("\(offset)\(self.description)")
        
        for child in children {
            child.printTree(level: level + 4)
        }
    }
    
    public static func diff(was: TreeNode<Value>?, became: TreeNode<Value>?) -> NodeDiff {
        
        if was == became {
            return .noChanged
        }
        
        var allChildren = [String]()
        var wasChildren = [String: TreeNode<Value>]()
        if let was = was {
            wasChildren = Dictionary(uniqueKeysWithValues:
                was.children.compactMap({ ($0.name, $0) })
            )
        }
        wasChildren.keys.forEach {
            if !allChildren.contains($0) {
                allChildren.append($0)
            }
        }
        var becameChildren = [String: TreeNode<Value>]()
        if let became = became {
            becameChildren = Dictionary(uniqueKeysWithValues:
                became.children.compactMap({ ($0.name, $0) })
            )
        }
        becameChildren.keys.forEach {
            if !allChildren.contains($0) {
                allChildren.append($0)
            }
        }
        let childrenDiff = allChildren.compactMap({
            diff(was: wasChildren[$0], became: becameChildren[$0])
        })
        
        if let was = was, let became = became {
            return .changed(was: was, became: became, children: childrenDiff)
        } else if let became = became {
            return appear(became: became, children: childrenDiff)
        } else if let was = was {
            return disappear(was: was, children: childrenDiff)
        } else {
            return .noChanged
        }
    }
}
