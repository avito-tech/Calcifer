import Foundation
import AtomicModels
import Toolkit

open class BaseChecksumHolder<ChecksumType: Checksum>:
    ChecksumHolder,
    CodableChecksumNodeConvertable,
    CustomStringConvertible,
    Hashable,
    Comparable
{

    public let name: String
    public let uniqIdentifier: UUID
    
    public var parents: ThreadSafeDictionary<String, BaseChecksumHolder<ChecksumType>>
    
    open var children: ThreadSafeDictionary<String, BaseChecksumHolder<ChecksumType>> {
        fatalError("Must be overriden")
    }
    
    private var state: AtomicValue<ChecksumState<ChecksumType>> = AtomicValue(.notCalculated)
    
    public init(
        uniqIdentifier: UUID = UUID(),
        name: String,
        parent: BaseChecksumHolder<ChecksumType>?)
    {
        self.uniqIdentifier = uniqIdentifier
        self.name = name
        self.parents = ThreadSafeDictionary<String, BaseChecksumHolder<ChecksumType>>()
        if let parent = parent {
            parents.write(parent, for: parent.name)
        }
    }
    
    public func obtainChecksum() throws -> ChecksumType {
        return try state.withExclusiveAccess { state in
            switch state {
            case let .calculated(checksum):
                return checksum
            case .notCalculated:
                let checksum = try calculateChecksum()
                state = .calculated(checksum)
                return checksum
            }
        }
    }
    
    public func updateState(checksum: ChecksumType) {
        for parent in parents.values {
            parent.invalidate()
        }
        state.withExclusiveAccess { state in
            state = .calculated(checksum)
        }
    }
    
    open func calculateChecksum() throws -> ChecksumType {
        fatalError("Must be overriden")
    }
    
    func haveNotCalculatedChildren() -> Bool {
        let notCalculated = children.values.filter { !$0.calculated }
        return !notCalculated.isEmpty
    }
    
    func obtainNotCalculatedLeafs() -> ThreadSafeDictionary<String, BaseChecksumHolder<ChecksumType>> {
        let visited = ThreadSafeDictionary<String, BaseChecksumHolder<ChecksumType>>()
        let notCalculatedLeafs = ThreadSafeDictionary<String, BaseChecksumHolder<ChecksumType>>()
        obtainNotCalculatedLeafs(visited: visited, leafs: notCalculatedLeafs)
        return notCalculatedLeafs
    }
    
    private func obtainNotCalculatedLeafs(
        visited: ThreadSafeDictionary<String, BaseChecksumHolder<ChecksumType>>,
        leafs: ThreadSafeDictionary<String, BaseChecksumHolder<ChecksumType>>)
    {
        guard visited.createIfNotExist(name, self).created else { return }
        if case .notCalculated = state.currentValue() {
            if !haveNotCalculatedChildren() {
                leafs.write(self, for: name)
                return
            }
            children.forEach { _, child in
                child.obtainNotCalculatedLeafs(visited: visited, leafs: leafs)
            }
        }
    }
    
    public func invalidate() {
        if state.withExclusiveAccess(work: { state in
            switch state {
            case .calculated:
                state = .notCalculated
                return true
            case .notCalculated:
                return false
            }
        }) {
            for parent in parents.values {
                parent.invalidate()
            }
        }
    }
    
    public var calculated: Bool {
        return state.withExclusiveAccess { state in
            switch state {
            case .calculated:
                return true
            case .notCalculated:
                return false
            }
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
        return state.withExclusiveAccess { state in
            switch state {
            case let .calculated(chacksum):
                return chacksum.stringValue
            case .notCalculated:
                return "-"
            }
        }
    }
    
    open var nodeChildren: [CodableChecksumNode<String>] {
        return children.values.sorted().map { $0.node() }
    }
}
