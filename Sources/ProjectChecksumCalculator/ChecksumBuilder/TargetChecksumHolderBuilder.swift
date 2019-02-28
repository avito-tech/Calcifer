import Foundation
import xcodeproj
import PathKit

final class TargetChecksumHolderBuilder<Builder: URLChecksumProducer> {
        
    let builder: FileChecksumHolderBuilder<Builder>
    
    init(builder: FileChecksumHolderBuilder<Builder>) {
        self.builder = builder
    }
    
    func build(
        target: PBXTarget,
        sourceRoot: Path,
        cached: inout [PBXTarget: TargetChecksumHolder<Builder.C>])
        throws -> TargetChecksumHolder<Builder.C>
    {
        var summarizedChecksums = [Builder.C]()
        let dependenciesTargets = target.dependencies.compactMap({ $0.target })
        let dependenciesChecksums = try dependenciesTargets.map { dependency -> TargetChecksumHolder<Builder.C> in
            if let dependencyChecksum = cached[dependency] {
                return dependencyChecksum
            }
            return try build(target: dependency, sourceRoot: sourceRoot, cached: &cached)
        }
        let dependenciesChecksum = try dependenciesChecksums.checksum()
        summarizedChecksums.append(dependenciesChecksum)
        
        let filesChecksums = try target.fileElements().map { file in
            try builder.build(file: file, sourceRoot: sourceRoot)
        }
        let filesChecksum = try filesChecksums.checksum()
        summarizedChecksums.append(filesChecksum)
        
        guard let summarizedChecksum = try summarizedChecksums.aggregate() else {
            throw ProjectChecksumError.emptyChecksum
        }
        
        return TargetChecksumHolder<Builder.C>(
            files: filesChecksums,
            dependencies: dependenciesChecksums,
            objectDescription: target.name,
            checksum: summarizedChecksum
        )
    }
}

extension PBXTarget {
    func fileElements() -> [PBXFileElement] {
        var files = [PBXFileElement]()
        if let sourcesBuildPhase = try? sourcesBuildPhase(),
            let sourcesFileElement = sourcesBuildPhase?.fileElements() {
            files.append(contentsOf: sourcesFileElement)
        }
        if let resourcesBuildPhase = try? resourcesBuildPhase(),
            let resourcesFileElement = resourcesBuildPhase?.fileElements()  {
            files.append(contentsOf: resourcesFileElement)
        }
        return files
    }
}

extension PBXBuildPhase {
    func fileElements() -> [PBXFileElement] {
        return files.compactMap { $0.file }
    }
}
