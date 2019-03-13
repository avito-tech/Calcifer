import Foundation
import xcodeproj
import Checksum
import PathKit

final class TargetChecksumHolderBuilder<Builder: URLChecksumProducer> {
        
    let builder: FileChecksumHolderBuilder<Builder>
    
    init(builder: FileChecksumHolderBuilder<Builder>) {
        self.builder = builder
    }
    
    typealias CacheWriter = ((PBXTarget, TargetChecksumHolder<Builder.ChecksumType>) -> ())
    typealias CacheReader = ((PBXTarget) -> (TargetChecksumHolder<Builder.ChecksumType>?))
    
    @discardableResult
    func build(
        target: PBXTarget,
        sourceRoot: Path,
        cacheReader: CacheReader,
        cacheWriter: CacheWriter)
        throws -> TargetChecksumHolder<Builder.ChecksumType>
    {
        if let cachedChecksum = cacheReader(target) {
            return cachedChecksum
        }
        var summarizedChecksums = [Builder.ChecksumType]()
        let dependenciesTargets = target.dependencies.compactMap { $0.target }
        let dependenciesChecksums = try dependenciesTargets.map {
            dependency -> TargetChecksumHolder<Builder.ChecksumType> in
            return try build(
                target: dependency,
                sourceRoot: sourceRoot,
                cacheReader: cacheReader,
                cacheWriter: cacheWriter
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
        guard let prodcutName = target.product?.path else {
            throw XcodeProjectChecksumCalculatorError.emptyProductName(
                target: target.name
            )
        }
        
        guard let prodcutTypeName = target.productType?.rawValue,
            let prodcutType = TargetProductType(rawValue: prodcutTypeName) else {
            throw XcodeProjectChecksumCalculatorError.emptyProductType(
                target: target.name
            )
        }
        
        let targetChecksumHolder = TargetChecksumHolder<Builder.ChecksumType>(
            targetName: target.name,
            productName: prodcutName,
            productType: prodcutType,
            checksum: summarizedChecksum,
            files: filesChecksums,
            dependencies: dependenciesChecksums
        )
        cacheWriter(target, targetChecksumHolder)
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
