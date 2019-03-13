import Foundation
import xcodeproj
import Checksum
import PathKit
import Toolkit

final class TargetChecksumHolderBuilder<Builder: URLChecksumProducer> {
        
    let builder: FileChecksumHolderBuilder<Builder>
    
    init(builder: FileChecksumHolderBuilder<Builder>) {
        self.builder = builder
    }
    
    @discardableResult
    func build(
        target: PBXTarget,
        sourceRoot: Path,
        cache: inout ThreadSafeDictionary<PBXTarget, TargetChecksumHolder<Builder.ChecksumType>>)
        throws -> TargetChecksumHolder<Builder.ChecksumType>
    {
        if let cachedChecksum = cache.read(target) {
            return cachedChecksum
        }
        var summarizedChecksums = [Builder.ChecksumType]()
        let dependenciesTargets = target.dependencies.compactMap { $0.target }
        let dependenciesChecksums = try dependenciesTargets.map {
            dependency -> TargetChecksumHolder<Builder.ChecksumType> in
            return try build(
                target: dependency,
                sourceRoot: sourceRoot,
                cache: &cache
            )
        }
        let dependenciesChecksum = try dependenciesChecksums.checksum()
        summarizedChecksums.append(dependenciesChecksum)
        
        let filesChecksums = try target.fileElements().map { file in
            try builder.build(file: file, sourceRoot: sourceRoot)
        }
        let filesChecksum = try filesChecksums.checksum()
        summarizedChecksums.append(filesChecksum)
        
        let summarizedChecksum = try summarizedChecksums.aggregate()
        
        // target.productName is not correct. Mb should use buildSettings
        guard let productName = target.product?.path else {
            throw XcodeProjectChecksumCalculatorError.emptyProductName(
                target: target.name
            )
        }
        
        guard let productTypeName = target.productType?.rawValue,
            let productType = TargetProductType(rawValue: productTypeName) else {
            throw XcodeProjectChecksumCalculatorError.emptyProductType(
                target: target.name
            )
        }
        
        let targetChecksumHolder = TargetChecksumHolder<Builder.ChecksumType>(
            targetName: target.name,
            productName: productName,
            productType: productType,
            checksum: summarizedChecksum,
            files: filesChecksums,
            dependencies: dependenciesChecksums
        )
        cache.write(targetChecksumHolder, for: target)
        return targetChecksumHolder
    }
}

extension PBXTarget {
    func fileElements() -> [PBXFileElement] {
        var files = [PBXFileElement]()
        if let sourcesBuildPhase = try? sourcesBuildPhase(),
            let sourcesFileElement = sourcesBuildPhase?.fileElements() {
            files.append(contentsOf: sourcesFileElement)
        }
        
        if let productType = productType, case .bundle = productType {
            if let resourcesBuildPhase = try? resourcesBuildPhase(),
                let resourcesFileElement = resourcesBuildPhase?.fileElements() {
                files.append(contentsOf: resourcesFileElement)
            }
        }
        return files
    }
}

extension PBXBuildPhase {
    func fileElements() -> [PBXFileElement] {
        return files.compactMap { $0.file }
    }
}