import Foundation
import XcodeProj
import PathKit
import Checksum
import Toolkit

final class ProjectChecksumHolderBuilder<Builder: URLChecksumProducer> {
    
    let builder: TargetChecksumHolderBuilder<Builder>
    
    init(builder: TargetChecksumHolderBuilder<Builder>) {
        self.builder = builder
    }
    
    func build(
        project: PBXProject,
        sourceRoot: Path)
        throws
        -> ProjectChecksumHolder<Builder.ChecksumType>
    {
        let targets = NSArray(array: project.targets)
        var cache = ThreadSafeDictionary<PBXTarget, TargetChecksumHolder<Builder.ChecksumType>>()
        var buildError: Error?
        targets.enumerateObjects(options: .concurrent) { obj, key, stop in
            if let target = obj as? PBXTarget {
                do {
                    try builder.build(
                        target: target,
                        sourceRoot: sourceRoot,
                        cache: &cache
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
                left.targetName > right.targetName
        })
        let summarizedChecksum = try summarizedChecksums.checksum()
        return ProjectChecksumHolder<Builder.ChecksumType>(
            targets: summarizedChecksums,
            description: project.name,
            checksum: summarizedChecksum
        )
    }
}
