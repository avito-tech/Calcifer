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
        var targetsChecksums = [PBXTarget: TargetChecksumHolder<Builder.C>]()
        targets.enumerateObjects(options: .concurrent) { obj, key, stop in
            if let target = obj as? PBXTarget {
                if let targetChecksum = try? builder.build(
                    target: target,
                    sourceRoot: sourceRoot,
                    cached: &targetsChecksums)
                {
                    lock.lock()
                    targetsChecksums[target] = targetChecksum
                    lock.unlock()
                }
            }
        }
        let summarizedChecksums = Array(targetsChecksums.values)
        let summarizedChecksum = try summarizedChecksums.checksum()
        return ProjectChecksumHolder<Builder.C>(
            targets: summarizedChecksums,
            description: project.name,
            checksum: summarizedChecksum
        )
    }
}
