import Foundation
import Toolkit

open class BaseChecksumHolder<ChecksumType: Checksum>:
    ChecksumHolder,
    CodableChecksumNodeConvertable,
    CustomStringConvertible,
    Hashable,
    Comparable
{

    public let name: String
    public let uniqIdentifier = UUID().uuidString
    
    public var parents: ThreadSafeDictionary<String, BaseChecksumHolder<ChecksumType>>
    
    open var children: [String: BaseChecksumHolder<ChecksumType>] {
        fatalError("Must be overriden")
    }
    
    private var state: ChecksumState<ChecksumType> = .notCalculated
    
    public init(name: String, parent: BaseChecksumHolder<ChecksumType>?) {
        self.name = name
        self.parents = ThreadSafeDictionary<String, BaseChecksumHolder<ChecksumType>>()
        if let parent = parent {
            parents.write(parent, for: parent.name)
        }
    }
    
    public func obtainChecksum() throws -> ChecksumType {
        switch state {
        case let .calculated(checksum):
            return checksum
        case .notCalculated:
            let checksum = try calculateChecksum()
            state = .calculated(checksum)
            return checksum
        }
    }
    
    public func updateState(checksum: ChecksumType) {
        for parent in parents.values {
            parent.invalidate()
        }
        state = .calculated(checksum)
    }
    
    public func smartChecksumCalculate() throws -> ChecksumType {
        var notCalculatedLeafs = obtainNotCalculatedLeafs()
        while !notCalculatedLeafs.isEmpty {
            try notCalculatedLeafs.enumerateKeysAndObjects(options: .concurrent) { _, node, _ in
                _ = try node.obtainChecksum()
            }
            var newNotCalculatedLeafs = [String: BaseChecksumHolder<ChecksumType>]()
            for (_, leaf) in notCalculatedLeafs {
                let notCalculatedParents = leaf.parents.values.filter { !$0.haveNotCalculatedChildren() }
                for notCalculatedParent in notCalculatedParents {
                    newNotCalculatedLeafs[notCalculatedParent.name] = notCalculatedParent
                }
            }
            notCalculatedLeafs = newNotCalculatedLeafs
        }
        let checksum = try obtainChecksum()
        return checksum
    }
    
    open func calculateChecksum() throws -> ChecksumType {
        fatalError("Must be overriden")
    }
    
    private func obtainNotCalculatedLeafs() -> [String: BaseChecksumHolder<ChecksumType>] {
        let visited = ThreadSafeDictionary<String, BaseChecksumHolder<ChecksumType>>()
        let notCalculatedLeafs = ThreadSafeDictionary<String, BaseChecksumHolder<ChecksumType>>()
        obtainNotCalculatedLeafs(visited: visited, leafs: notCalculatedLeafs)
        return notCalculatedLeafs.obtainDictionary()
    }
    
    private func obtainNotCalculatedLeafs(
        visited: ThreadSafeDictionary<String, BaseChecksumHolder<ChecksumType>>,
        leafs: ThreadSafeDictionary<String, BaseChecksumHolder<ChecksumType>>)
    {
        guard visited.read(name) == nil else {
            return
        }
        visited.write(self, for: name)
        if case .notCalculated = state {
            if !haveNotCalculatedChildren() {
                leafs.write(self, for: name)
                return
            }
            for (_, child) in children {
                child.obtainNotCalculatedLeafs(visited: visited, leafs: leafs)
            }
        }
    }
    
    private func haveNotCalculatedChildren() -> Bool {
        let notCalculated = children.values.filter { !$0.calculated }
        return !notCalculated.isEmpty
    }
    
    public func invalidate() {
        switch state {
        case .calculated:
            state = .notCalculated
            for parent in parents.values {
                parent.invalidate()
            }
        case .notCalculated:
            return
        }
    }
    
    public var calculated: Bool {
        switch state {
        case .calculated:
            return true
        case .notCalculated:
            return false
        }
    }
    
    // MARK: - CustomStringConvertible
    public var description: String {
        return name
    }
    
    // MARK: - Equatable
    public static func == (lhs: BaseChecksumHolder, rhs: BaseChecksumHolder) -> Bool {
        return lhs.name == rhs.name
    }
    
    // MARK: - Hashable
    public func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
    
    // MARK: - Comparable
    public static func < (lhs: BaseChecksumHolder, rhs: BaseChecksumHolder) -> Bool {
        return lhs.name < rhs.name
    }
    
    // MARK: - CodableChecksumNodeConvertable
    public func node() -> CodableChecksumNode<String> {
        return CodableChecksumNode(
            name: name,
            value: nodeValue,
            children: nodeChildren
        )
    }
    
    public var nodeValue: String {
        switch state {
        case let .calculated(chacksum):
            return chacksum.stringValue
        case .notCalculated:
            return "-"
        }
    }
    
    open var nodeChildren: [CodableChecksumNode<String>] {
        return children.values.sorted().map { $0.node() }
    }
}
