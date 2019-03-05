import Foundation
import xcodeproj
import PathKit

final class ProjectChecksumHolderBuilder<Builder: URLChecksumProducer> {
    
    let builder: TargetChecksumHolderBuilder<Builder>
    
    init(builder: TargetChecksumHolderBuilder<Builder>) {
        self.builder = builder
    }
    
    func build(project: PBXProject, sourceRoot: Path) throws -> ProjectChecksumHolder<Builder.C> {
        let targets = NSArray(array: project.targets)
        // In this situation, it is more correct to use the DispatchQueue, not the lock,
        // because the queue guarantees the absence of a double write, but it works twice as long.
        // Performance is more important than this warranty, so I left the lock.
        let lock = NSRecursiveLock()
        var cache = [PBXTarget: TargetChecksumHolder<Builder.C>]()
        let cacheReader: TargetChecksumHolderBuilder<Builder>.CacheReader = { targetName in
            cache[targetName]
        }
        let cacheWriter: TargetChecksumHolderBuilder<Builder>.CacheWriter = { target, checksumHolder  in
            lock.lock()
            cache[target] = checksumHolder
            lock.unlock()
        }
        var buildError: Error?
        targets.enumerateObjects(options: .concurrent) { obj, key, stop in
            if let target = obj as? PBXTarget {
                do {
                try builder.build(
                    target: target,
                    sourceRoot: sourceRoot,
                    cacheReader: cacheReader,
                    cacheWriter: cacheWriter
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
        let summarizedChecksums = Array(
            cache.values.sorted(by: {left, right -> Bool in
                left.name > right.name
            })
        )
        let summarizedChecksum = try summarizedChecksums.checksum()
        return ProjectChecksumHolder<Builder.C>(
            targets: summarizedChecksums,
            description: project.name,
            checksum: summarizedChecksum
        )
    }
}
