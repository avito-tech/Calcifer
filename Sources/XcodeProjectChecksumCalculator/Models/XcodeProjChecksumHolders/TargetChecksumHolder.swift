import Foundation
import Checksum

struct TargetChecksumHolder<C: Checksum>: ChecksumHolder {
    let targetName: String
    let productName: String
    let productType: TargetProductType
    let checksum: C
    let files: [FileChecksumHolder<C>]
    let dependencies: [TargetChecksumHolder<C>]
    
    init(
        targetName: String,
        productName: String,
        productType: TargetProductType,
        checksum: C,
        files: [FileChecksumHolder<C>],
        dependencies: [TargetChecksumHolder<C>])
    {
        self.targetName = targetName
        self.productName = productName
        self.productType = productType
        self.checksum = checksum
        self.files = files
        self.dependencies = dependencies
    }
    
    var allDependencies: [TargetChecksumHolder<C>] {
        let all = dependencies + dependencies.flatMap { $0.allDependencies }
        var uniq = [String: TargetChecksumHolder<C>]()
        for dependency in all {
            uniq[dependency.targetName] = dependency
        }
        
        return Array(uniq.values)
    }
    
    // MARK: - CustomStringConvertible
    var description: String {
        return targetName
    }
    
    // MARK: - Codable
    enum CodingKeys: String, CodingKey {
        case targetName
        case productName
        case productType
        case checksum
        case files
        case dependencies
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(targetName, forKey: .targetName)
        try container.encode(productName, forKey: .productName)
        try container.encode(checksum, forKey: .checksum)
        try container.encode(files, forKey: .files)
        // Performance issue
        let dependenciesNames = dependencies.map({ $0.targetName })
        try container.encode(dependenciesNames, forKey: .dependencies)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        targetName = try container.decode(String.self, forKey: .targetName)
        productName = try container.decode(String.self, forKey: .productName)
        productType = try container.decode(TargetProductType.self, forKey: .productType)
        checksum = try container.decode(C.self, forKey: .checksum)
        files = try container.decode([FileChecksumHolder<C>].self, forKey: .files)
        // Performance issue
        dependencies = [TargetChecksumHolder<C>]()
    }
}

extension TargetChecksumHolder: TreeNodeConvertable {
    
    func node() -> TreeNode<C> {
        let children = files.nodeList() + dependencies.nodeList()
        return TreeNode<C>(
            name: targetName,
            value: checksum,
            children: children
        )
    }
    
}
