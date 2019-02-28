import Foundation
import xcodeproj
import PathKit

final class TargetChecksumHolderBuilder<Builder: URLChecksumProducer> {
        
    let builder: FileChecksumHolderBuilder<Builder>
    
    init(builder: FileChecksumHolderBuilder<Builder>) {
        self.builder = builder
    }
    
    func build(target: PBXTarget, sourceRoot: Path) throws -> TargetChecksumHolder<Builder.C> {
        let filesChecksums = try target.fileElements().map { file in
            try builder.build(file: file, sourceRoot: sourceRoot)
        }
        let checksum = try filesChecksums.checksum()
        return TargetChecksumHolder<Builder.C>(
            files: filesChecksums,
            objectDescription: target.name,
            checksum: checksum
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
