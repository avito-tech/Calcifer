import Foundation
import XcodeProj
import PathKit
import Checksum
import Toolkit

final class ProjectChecksumHolderBuilder<ChecksumProducer: URLChecksumProducer> {
    
    private let builder: TargetChecksumHolderBuilder<ChecksumProducer>
    
    init(builder: TargetChecksumHolderBuilder<ChecksumProducer>) {
        self.builder = builder
    }
    
    func build(
        parent: ProjChecksumHolder<ChecksumProducer.ChecksumType>,
        project: PBXProject,
        sourceRoot: Path,
        concurrent: Bool = true)
        throws
        -> ProjectChecksumHolder<ChecksumProducer.ChecksumType>
    {
        
        let projectChecksumHolder = ProjectChecksumHolder<ChecksumProducer.ChecksumType>(
            name: project.name,
            parent: parent
        )
        let cache = ThreadSafeDictionary<PBXTarget, TargetChecksumHolder<ChecksumProducer.ChecksumType>>()
        if concurrent {
            try concurrentBuild(
                project: project,
                projectChecksumHolder: projectChecksumHolder,
                sourceRoot: sourceRoot,
                cache: cache
            )
        } else {
            try build(
                project: project,
                projectChecksumHolder: projectChecksumHolder,
                sourceRoot: sourceRoot,
                cache: cache
            )
        }
        return projectChecksumHolder
    }
    
    private func concurrentBuild(
        project: PBXProject,
        projectChecksumHolder: ProjectChecksumHolder<ChecksumProducer.ChecksumType>,
        sourceRoot: Path,
        cache: ThreadSafeDictionary<PBXTarget, TargetChecksumHolder<ChecksumProducer.ChecksumType>>)
        throws
    {
        
        let targets = NSArray(array: project.targets)
        var buildError: Error?
        
        targets.enumerateObjects(options: .concurrent) { obj, _, stop in
            if let target = obj as? PBXTarget {
                do {
                    try builder.build(
                        parent: projectChecksumHolder,
                        target: target,
                        sourceRoot: sourceRoot,
                        cache: cache
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
        projectChecksumHolder.update(targets: cache.values)
    }
    
    private func build(
        project: PBXProject,
        projectChecksumHolder: ProjectChecksumHolder<ChecksumProducer.ChecksumType>,
        sourceRoot: Path,
        cache: ThreadSafeDictionary<PBXTarget, TargetChecksumHolder<ChecksumProducer.ChecksumType>>)
        throws
    {
        try project.targets.forEach {
            try builder.build(
                parent: projectChecksumHolder,
                target: $0,
                sourceRoot: sourceRoot,
                cache: cache
            )
        }
    }
}
