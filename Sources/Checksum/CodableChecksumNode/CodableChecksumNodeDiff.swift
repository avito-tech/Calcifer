import Foundation

public enum CodableChecksumNodeDiff<Value: Codable & Hashable>: CustomStringConvertible {
    case noChanged
    case changed(previousValue: CodableChecksumNode<Value>, newValue: CodableChecksumNode<Value>, children: [CodableChecksumNodeDiff])
    case appear(newValue: CodableChecksumNode<Value>, children: [CodableChecksumNodeDiff])
    case disappear(previousValue: CodableChecksumNode<Value>, children: [CodableChecksumNodeDiff])
    
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
        case let .changed(previousValue, newValue, _):
            return "changed was: \(previousValue) became: \(newValue)"
        case let .appear(newValue, _):
            return "appear: \(newValue)"
        case let .disappear(previousValue, _):
            return "disappear: \(previousValue)"
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
    
    public var previousValue: CodableChecksumNode<Value>? {
        switch self {
        case .noChanged:
            return nil
        case let .changed(previousValue, _, _):
            return previousValue
        case .appear:
            return nil
        case let .disappear(previousValue, _):
            return previousValue
        }
    }
    
    public var newValue: CodableChecksumNode<Value>? {
        switch self {
        case .noChanged:
            return nil
        case let .changed(_, newValue, _):
            return newValue
        case let .appear(newValue, _):
            return newValue
        case .disappear:
            return nil
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
        if children.isEmpty {
            return
        }
        let changedChildren = children.filter { !$0.noChanged }
        if changedChildren.isEmpty {
            if !noChanged {                
                alreadyPrinted.insert(description)
                print(description)
            }
        } else {
            for child in children {
                child.printLeafs(alreadyPrinted: &alreadyPrinted)
            }
        }
    }
    
    public static func diff(previousValue: CodableChecksumNode<Value>?, newValue: CodableChecksumNode<Value>?) -> CodableChecksumNodeDiff {
        
        if previousValue == newValue {
            return .noChanged
        }
        
        var allChildren = [String]()
        var previousValueChildren = [String: CodableChecksumNode<Value>]()
        if let previousValue = previousValue {
            previousValueChildren = Dictionary(uniqueKeysWithValues:
                previousValue.children.compactMap({ ($0.name, $0) })
            )
        }
        previousValueChildren.keys.forEach {
            if !allChildren.contains($0) {
                allChildren.append($0)
            }
        }
        var newValueChildren = [String: CodableChecksumNode<Value>]()
        if let newValue = newValue {
            newValueChildren = Dictionary(uniqueKeysWithValues:
                newValue.children.compactMap({ ($0.name, $0) })
            )
        }
        newValueChildren.keys.forEach {
            if !allChildren.contains($0) {
                allChildren.append($0)
            }
        }
        let childrenDiff = allChildren.compactMap({
            diff(previousValue: previousValueChildren[$0], newValue: newValueChildren[$0])
        })
        
        if let previousValue = previousValue, let newValue = newValue {
            return .changed(previousValue: previousValue, newValue: newValue, children: childrenDiff)
        } else if let newValue = newValue {
            return appear(newValue: newValue, children: childrenDiff)
        } else if let previousValue = previousValue {
            return disappear(previousValue: previousValue, children: childrenDiff)
        } else {
            return .noChanged
        }
    }
}
