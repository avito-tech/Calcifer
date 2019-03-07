import Foundation
import xcodeproj
import PathKit
import Checksum
import Toolkit

final class ProjectChecksumHolderBuilder<Builder: URLChecksumProducer> {
    
    let builder: TargetChecksumHolderBuilder<Builder>
    
    init(builder: TargetChecksumHolderBuilder<Builder>) {
        self.builder = builder
    }
    
    func build(project: PBXProject, sourceRoot: Path) throws -> ProjectChecksumHolder<Builder.C> {
        let targets = NSArray(array: project.targets)
        let cache = ThreadSafeDictionary<PBXTarget, TargetChecksumHolder<Builder.C>>()
        var buildError: Error?
        targets.enumerateObjects(options: .concurrent) { obj, key, stop in
            if let target = obj as? PBXTarget {
                do {
                    try builder.build(
                        target: target,
                        sourceRoot: sourceRoot,
                        cacheReader: cache.read,
                        cacheWriter: cache.write
                    )
                } catch {
                    buildError = error
                    stop.pointee = true
                    return
                }
            }
        }
        if let error = buildError {
            throw error
        }
        let summarizedChecksums = cache.values.sorted(by: {left, right -> Bool in
                left.name > right.name
        })
        let summarizedChecksum = try summarizedChecksums.checksum()
        return ProjectChecksumHolder<Builder.C>(
            targets: summarizedChecksums,
            description: project.name,
            checksum: summarizedChecksum
        )
    }
}
