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
    
    public var state: ChecksumState<ChecksumType> = .notCalculated
    
    public init(name: String, parent: BaseChecksumHolder<ChecksumType>?) {
        self.name = name
        self.parent = parent
    }
    
    open func obtainChecksum<ChecksumProducer: URLChecksumProducer>(checksumProducer: ChecksumProducer)
        throws -> ChecksumType
        where ChecksumProducer.ChecksumType == ChecksumType
    {
        fatalError("Must be overriden")
    }
    
    public func cached(_ calculate: () throws -> (ChecksumType)) throws -> ChecksumType {
        switch state {
        case let .calculated(checksum):
            return checksum
        case .notCalculated:
            let checksum = try calculate()
            state = .calculated(checksum)
            return checksum
        }
    }
    
    public func smartCalculate<ChecksumProducer: URLChecksumProducer>(checksumProducer: ChecksumProducer)
        throws -> ChecksumType
        where ChecksumProducer.ChecksumType == ChecksumType
    {
        var visited = [String: BaseChecksumHolder<ChecksumType>]()
        var notCalculatedLeafs = obtainNotCalculatedLeafs(visited: &visited)
        var calculateError: Error?
        while !notCalculatedLeafs.isEmpty {
            let array = notCalculatedLeafs as NSDictionary
            array.enumerateKeysAndObjects(options: .concurrent) { _, object, stop in
                if let node = object as? BaseChecksumHolder<ChecksumType> {
                    do {
                        _ = try node.obtainChecksum(checksumProducer: checksumProducer)
                    } catch {
                        calculateError = error
                        stop.pointee = true
                        return
                    }
                }
            }
            if let error = calculateError {
                throw error
            }
            visited = notCalculatedLeafs
            notCalculatedLeafs = obtainNotCalculatedLeafs(visited: &visited)
        }
        return try obtainChecksum(checksumProducer: checksumProducer)
    }
    
    func obtainNotCalculatedLeafs( visited: inout [String: BaseChecksumHolder<ChecksumType>]) -> [String: BaseChecksumHolder<ChecksumType>] {
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
        return children.values.map { $0.node() }
    }
}
