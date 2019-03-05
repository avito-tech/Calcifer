import Foundation
import xcodeproj
import PathKit

final class TargetChecksumHolderBuilder<Builder: URLChecksumProducer> {
        
    let builder: FileChecksumHolderBuilder<Builder>
    
    init(builder: FileChecksumHolderBuilder<Builder>) {
        self.builder = builder
    }
    
    public typealias CacheWriter = ((PBXTarget, TargetChecksumHolder<Builder.C>) -> ())
    public typealias CacheReader = ((PBXTarget) -> (TargetChecksumHolder<Builder.C>?))
    
    @discardableResult
    func build(
        target: PBXTarget,
        sourceRoot: Path,
        cacheReader: CacheReader,
        cacheWriter: CacheWriter)
        throws -> TargetChecksumHolder<Builder.C>
    {
        if let cachedChecksum = cacheReader(target) {
            return cachedChecksum
        }
        var summarizedChecksums = [Builder.C]()
        let dependenciesTargets = target.dependencies.compactMap({ $0.target })
        let dependenciesChecksums = try dependenciesTargets.map { dependency -> TargetChecksumHolder<Builder.C> in
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
        
        let targetChecksumHolder = TargetChecksumHolder<Builder.C>(
            name: target.name,
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
        // TODO: Fix after MVP
        
//        if let resourcesBuildPhase = try? resourcesBuildPhase(),
//            let resourcesFileElement = resourcesBuildPhase?.fileElements() {
//            files.append(contentsOf: resourcesFileElement)
//        }
        return files
    }
}

extension PBXBuildPhase {
    func fileElements() -> [PBXFileElement] {
        return files.compactMap { $0.file }
    }
}
