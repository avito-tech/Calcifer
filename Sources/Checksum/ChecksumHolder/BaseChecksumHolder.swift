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
    private let uniqIdentifier = UUID().uuidString
    
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
    
    public func validate() throws {
        try validateAllChecksumCalculated()
        try validateChecksuMatch()
        try validateUniqueness()
    }
    
    private func validateAllChecksumCalculated() throws {
        let validated = ThreadSafeDictionary<String, BaseChecksumHolder<ChecksumType>>()
        try validateAllChecksumCalculated(validated: validated)
    }
    
    private func validateAllChecksumCalculated(
        validated: ThreadSafeDictionary<String, BaseChecksumHolder<ChecksumType>>)
        throws
    {
        guard validated.read(uniqIdentifier) == nil else { return }
        validated.write(self, for: uniqIdentifier)
        guard calculated else {
            throw ChecksumError.notCalculatedChecksum(name: name)
        }
        for child in children.values {
            try child.validateAllChecksumCalculated(validated: validated)
        }
    }
    
    private func validateChecksuMatch() throws {
        let validated = ThreadSafeDictionary<String, BaseChecksumHolder<ChecksumType>>()
        try validate(validated: validated)
    }
    
    private func validate(
        validated: ThreadSafeDictionary<String, BaseChecksumHolder<ChecksumType>>)
        throws
    {
        if validated.read(self.name) != nil {
            return
        }
        if children.isEmpty {
            return
        }
        let currentChecksum = try obtainChecksum().stringValue
        let childrenChecksum = try children.values.sorted().map {
            try $0.obtainChecksum()
        }.aggregate().stringValue
        if currentChecksum != childrenChecksum {
            throw ChecksumError.checksumMismatch(
                name: name,
                currentChecksum: currentChecksum,
                childrenChecksum: childrenChecksum
            )
        }
        validated.write(self, for: name)
        try children.enumerateKeysAndObjects(options: .concurrent) { _, child, _ in
            try child.validate(validated: validated)
        }
    }
    
    private func validateUniqueness() throws {
        let visited = ThreadSafeDictionary<String, BaseChecksumHolder<ChecksumType>>()
        try validateUniqueness(visited: visited)
    }
    
    public func validateUniqueness(
        visited: ThreadSafeDictionary<String, BaseChecksumHolder<ChecksumType>>)
        throws
    {
        let holder = visited.read(name)
        if let holder = holder {
            if holder.uniqIdentifier != uniqIdentifier {
                throw ChecksumError.dublicateChecksumHolder(name: holder.name)
            }
            return
        }
        visited.write(self, for: name)
        try children.enumerateKeysAndObjects(options: .concurrent) { _, child, _ in
            try child.validateUniqueness(visited: visited)
        }
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
