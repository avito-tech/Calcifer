import Foundation

struct NodeDiff {
    let was: TreeNode?
    let became: TreeNode?
    let children: [NodeDiff]
    
    init(was: TreeNode?, became: TreeNode?, children: [NodeDiff]) {
        self.was = was
        self.became = became
        self.children = children
    }
    
    func printTree(level: Int = 0) {
        let offset = String(repeating: " ", count: level)
        print("\(offset)was: \(was?.description ?? "-") became: \(became?.description ?? "-")")
        
        for child in children {
            child.printTree(level: level + 4)
        }
    }
    
    static func diff(was: TreeNode?, became: TreeNode?) -> NodeDiff? {
        if was == became {
            return nil
        }
        var allChildren = [String]()
        var wasChildren = [String : TreeNode]()
        if let was = was {
            wasChildren = Dictionary(uniqueKeysWithValues:
                was.children?.compactMap({ ($0.name, $0) }) ?? []
            )
        }
        wasChildren.keys.forEach {
            if !allChildren.contains($0) {
                allChildren.append($0)
            }
        }
        var becameChildren = [String : TreeNode]()
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
            diff(was: wasChildren[$0], became: becameChildren[$0])
        })
        return NodeDiff(was: was, became: became, children: childrenDiff)
    }
}
