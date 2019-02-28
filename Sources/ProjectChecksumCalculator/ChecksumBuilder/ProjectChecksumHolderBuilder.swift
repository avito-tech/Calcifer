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
        let lock = NSRecursiveLock()
        var targetsChecksums = [TargetChecksumHolder<Builder.C>]()
        targets.enumerateObjects(options: .concurrent) { obj, key, stop in
            if let target = obj as? PBXTarget {
                if let targetChecksum = try? builder.build(
                    target: target,
                    sourceRoot: sourceRoot)
                {
                    lock.lock()
                    targetsChecksums.append(targetChecksum)
                    lock.unlock()
                }
            }
        }
        let checksum = try targetsChecksums.checksum()
        return ProjectChecksumHolder<Builder.C>(
            targets: targetsChecksums,
            objectDescription: project.name,
            checksum: checksum
        )
    }
}
