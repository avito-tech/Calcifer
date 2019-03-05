import Foundation

public struct NodeDiff {
    let was: Node?
    let became: Node?
    let children: [NodeDiff]
    
    init(was: Node?, became: Node?, children: [NodeDiff]) {
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
}

extension Node {
    func diff(became: Node?) -> NodeDiff? {
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
        return NodeDiff(was: self, became: became, children: childrenDiff)
    }
}
