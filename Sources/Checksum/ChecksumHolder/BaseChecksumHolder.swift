import Foundation

open class BaseChecksumHolder<ChecksumType: Checksum>:
    ChecksumHolder,
    CodableChecksumNodeConvertable,
    CustomStringConvertible,
    Hashable,
    Comparable
{

    public let name: String
    
    public let parent: BaseChecksumHolder<ChecksumType>?
    
    open var children: [String: BaseChecksumHolder<ChecksumType>] {
        fatalError("Must be overriden")
    }
    
    private var state: ChecksumState<ChecksumType> = .notCalculated
    
    public init(name: String, parent: BaseChecksumHolder<ChecksumType>?) {
        self.name = name
        self.parent = parent
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
        parent?.invalidate()
        state = .calculated(checksum)
    }
    
    public func smartChecksumCalculate() throws -> ChecksumType {
        var visited = [String: BaseChecksumHolder<ChecksumType>]()
        var notCalculatedLeafs = obtainNotCalculatedLeafs(visited: &visited)
        while !notCalculatedLeafs.isEmpty {
            try notCalculatedLeafs.enumerateKeysAndObjects(options: .concurrent) { _, node, stop in
                _ = try node.obtainChecksum()
            }
            visited = notCalculatedLeafs
            notCalculatedLeafs = obtainNotCalculatedLeafs(visited: &visited)
        }
        return try obtainChecksum()
    }
    
    open func calculateChecksum() throws -> ChecksumType {
        fatalError("Must be overriden")
    }
    
    private func obtainNotCalculatedLeafs( visited: inout [String: BaseChecksumHolder<ChecksumType>]) -> [String: BaseChecksumHolder<ChecksumType>] {
        guard visited[name] == nil else {
            return [:]
        }
        visited[name] = self
        var result = [String: BaseChecksumHolder<ChecksumType>]()
        if case .notCalculated = state {
            for (_, child) in children {
                let values = child.obtainNotCalculatedLeafs(visited: &visited)
                if !values.isEmpty {
                    result.merge(values, uniquingKeysWith: { first, _ in first })
                }
            }
            if result.isEmpty {
                return [name: self]
            }
        }
        return result
    }
    
    public func invalidate() {
        switch state {
        case .calculated:
            state = .notCalculated
            parent?.invalidate()
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
