import Foundation
import Checksum

class TargetChecksumHolder<ChecksumType: Checksum>: BaseChecksumHolder<ChecksumType> {
    
    override var children: [String: BaseChecksumHolder<ChecksumType>] {
        var childrenChecksums = [String: BaseChecksumHolder<ChecksumType>]()
        let filesChecksums = files as [String: BaseChecksumHolder<ChecksumType>]
        let dependenciesChecksums = dependencies as [String: BaseChecksumHolder<ChecksumType>]
        childrenChecksums = childrenChecksums.merging(filesChecksums, uniquingKeysWith: { (first, _) in first })
        childrenChecksums = childrenChecksums.merging(dependenciesChecksums, uniquingKeysWith: { (first, _) in first })
        return childrenChecksums
    }
    
    let targetName: String
    let productName: String
    let productType: TargetProductType

    var files = [String: FileChecksumHolder<ChecksumType>]()
    var dependencies = [String: TargetChecksumHolder<ChecksumType>]()
    
    init(
        targetName: String,
        productName: String,
        productType: TargetProductType,
        parent: BaseChecksumHolder<ChecksumType>)
    {
        self.targetName = targetName
        self.productName = productName
        self.productType = productType
        super.init(
            name: "\(targetName)-\(productName)-\(productType)",
            parent: parent
        )
    }
    
    private var cachedAllFlatDependencies: [TargetChecksumHolder<ChecksumType>]?
    
    var allFlatDependencies: [TargetChecksumHolder<ChecksumType>] {
        if let cachedAllDependencies = cachedAllFlatDependencies {
            return cachedAllDependencies
        }
        let all = dependencies.values + dependencies.flatMap { $0.value.allFlatDependencies }
        var uniq = [String: TargetChecksumHolder<ChecksumType>]()
        for dependency in all {
            uniq[dependency.targetName] = dependency
        }
        let result = Array(uniq.values)
        cachedAllFlatDependencies = result
        return result
    }
    
    override func obtainChecksum<ChecksumProducer: URLChecksumProducer>(checksumProducer: ChecksumProducer)
        throws -> ChecksumType
        where ChecksumProducer.ChecksumType == ChecksumType
    {
        return try cached {
            let filesChecksum = try files.values.sorted().map {
                try $0.obtainChecksum(checksumProducer: checksumProducer)
            }.aggregate()
            let dependenciesChecksum = try dependencies.values.sorted().map {
                try $0.obtainChecksum(checksumProducer: checksumProducer)
            }.aggregate()
            return try [
                filesChecksum,
                dependenciesChecksum
            ].aggregate()
        }
    }
    
    func update(filesChecksums: [FileChecksumHolder<ChecksumType>], dependenciesChecksums: [TargetChecksumHolder<ChecksumType>]) {
        self.files = Dictionary(uniqueKeysWithValues: filesChecksums.map { ($0.name, $0) })
        self.dependencies = Dictionary(uniqueKeysWithValues: dependenciesChecksums.map { ($0.name, $0) })
        state = .notCalculated
    }
    
    override open var nodeChildren: [CodableChecksumNode<String>] {
        let dependencyNodes = dependencies.values.map { dependency in
            CodableChecksumNode<String>(
                name: dependency.name,
                value: dependency.nodeValue,
                children: []
            )
        }
        let fileNodes = files.values.map{ $0.node() }
        return dependencyNodes + fileNodes
    }
    
}
