import Foundation
import XcodeProj
import Checksum
import PathKit
import Toolkit

final class TargetChecksumHolderBuilder<ChecksumProducer: URLChecksumProducer> {
        
    let builder: FileChecksumHolderBuilder<ChecksumProducer>
    
    init(builder: FileChecksumHolderBuilder<ChecksumProducer>) {
        self.builder = builder
    }
    
    @discardableResult
    func build(
        parent: BaseChecksumHolder<ChecksumProducer.ChecksumType>,
        target: PBXTarget,
        sourceRoot: Path,
        cache: ThreadSafeDictionary<PBXTarget, TargetChecksumHolder<ChecksumProducer.ChecksumType>>)
        throws -> TargetChecksumHolder<ChecksumProducer.ChecksumType>
    {
        if let cachedChecksum = cache.read(target) {
            return cachedChecksum
        }
        let targetChecksumHolder = try createTargetChecksumHolder(
            target: target,
            parent: parent
        )
        cache.write(targetChecksumHolder, for: target)
        
        let dependenciesTargets = target.dependencies.compactMap { $0.target }
        let dependenciesChecksums = try dependenciesTargets.map {
                dependency -> TargetChecksumHolder<ChecksumProducer.ChecksumType> in
            try build(
                parent: targetChecksumHolder,
                target: dependency,
                sourceRoot: sourceRoot,
                cache: cache
            )
        }
        
        let filesChecksums = try target.fileElements().map { file in
            try builder.build(
                parent: targetChecksumHolder,
                file: file,
                sourceRoot: sourceRoot
            )
        }
        
        targetChecksumHolder.update(
            files: filesChecksums,
            dependencies: dependenciesChecksums
        )
        
        return targetChecksumHolder
    }
    
    private func createTargetChecksumHolder(target: PBXTarget, parent: BaseChecksumHolder<ChecksumProducer.ChecksumType>)
        throws -> TargetChecksumHolder<ChecksumProducer.ChecksumType>
    {
        var productType: TargetProductType
        if let productTypeName = target.productType?.rawValue,
            let currentProductType = TargetProductType(rawValue: productTypeName) {
            productType = currentProductType
        } else {
            productType = .none
        }
        
        let productName = try obtainProductName(for: target, type: productType)
        
        let targetChecksumHolder = TargetChecksumHolder<ChecksumProducer.ChecksumType>(
            targetName: target.name,
            productName: productName,
            productType: productType,
            parent: parent
        )
        
        return targetChecksumHolder
    }
    
    private func obtainProductName(for target: PBXTarget, type: TargetProductType) throws -> String {
        // target.productName is not correct. Mb should use buildSettings
        if let productName = target.product?.name,
            isValidProductName(productName, type: type) {
            return productName
        }
        if let productName = target.product?.path,
            isValidProductName(productName, type: type) {
            return productName
        }
        if let productName = target.productNameWithExtension(),
            isValidProductName(productName, type: type) {
            return productName
        }
        throw XcodeProjectChecksumCalculatorError.emptyProductName(
            target: target.name
        )
    }
    
    private func isValidProductName(_ productName: String, type: TargetProductType) -> Bool {
        switch type {
        case .framework:
            return productName.contains("-") == false
        default:
            return true
        }
    }
}

extension PBXTarget {
    func fileElements() -> [PBXFileElement] {
        var files = [PBXFileElement]()
        if let sourcesBuildPhase = try? sourcesBuildPhase() {
            let sourcesFileElement = sourcesBuildPhase.fileElements()
            files.append(contentsOf: sourcesFileElement)
        }
        
        if let productType = productType, case .bundle = productType {
            if let resourcesBuildPhase = try? resourcesBuildPhase() {
                let resourcesFileElement = resourcesBuildPhase.fileElements()
                files.append(contentsOf: resourcesFileElement)
            }
        }
        return files
    }
}

extension PBXBuildPhase {
    func fileElements() -> [PBXFileElement] {
        guard let files = files else { return [PBXFileElement]() }
        return files.compactMap { $0.file }
    }
}
