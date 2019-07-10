import Foundation

public enum CodableChecksumNodeDiff<Value: Codable & Hashable>: CustomStringConvertible {
    case noChanged
    case changed(was: CodableChecksumNode<Value>, became: CodableChecksumNode<Value>, children: [CodableChecksumNodeDiff])
    case appear(became: CodableChecksumNode<Value>, children: [CodableChecksumNodeDiff])
    case disappear(was: CodableChecksumNode<Value>, children: [CodableChecksumNodeDiff])
    
    public var children: [CodableChecksumNodeDiff] {
        switch self {
        case .noChanged:
            return [CodableChecksumNodeDiff]()
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
    
    public var noChanged: Bool {
        switch self {
        case .noChanged:
            return true
        case .changed:
            return false
        case .appear:
            return false
        case .disappear:
            return false
        }
    }
    
    public func printLeafs() {
        var alreadyPrinted = Set<String>()
        printLeafs(alreadyPrinted: &alreadyPrinted)
    }
    
    private func printLeafs(alreadyPrinted: inout Set<String>) {
        guard alreadyPrinted.contains(description) == false else {
            return
        }
        let changedChildren = children.filter { !$0.noChanged }
        if changedChildren.isEmpty {
            if case .noChanged = self {
                return
            }
            alreadyPrinted.insert(description)
            print(description)
        } else {
            for child in children {
                child.printLeafs(alreadyPrinted: &alreadyPrinted)
            }
        }
    }
    
    public static func diff(was: CodableChecksumNode<Value>?, became: CodableChecksumNode<Value>?) -> CodableChecksumNodeDiff {
        
        if was == became {
            return .noChanged
        }
        
        var allChildren = [String]()
        var wasChildren = [String: CodableChecksumNode<Value>]()
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
        var becameChildren = [String: CodableChecksumNode<Value>]()
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
