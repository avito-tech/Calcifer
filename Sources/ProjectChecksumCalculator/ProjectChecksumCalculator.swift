import Foundation
import xcodeproj
import PathKit
import Toolkit

public final class ProjectChecksumCalculator {
    
    public init() {}
    
    @discardableResult
    func calculate(projectPath: String) throws -> String? {
        let path = Path(projectPath)
        let xcodeproject = try XcodeProj(path: path)
        let pbxproj = xcodeproject.pbxproj
        let sourceRoot = Path(components: Array(path.components.dropLast()))
        let projChecksum = try calculateChecksum(for: pbxproj, sourceRoot: sourceRoot)
        return projChecksum.checksum
    }
    
    private func calculateChecksum(for pbxproj: PBXProj, sourceRoot: Path) throws -> ProjChecksum {
        let projectsCecksums = try pbxproj.projects.map { project in
            try calculateChecksum(for: project, sourceRoot: sourceRoot)
        }
        let checksum = try projectsCecksums.checksum()
        return ProjChecksum(
            projects: projectsCecksums,
            checksum: checksum
        )
    }
    
    private func calculateChecksum(
        for project: PBXProject,
        sourceRoot: Path) throws -> ProjectChecksum
    {
        let targets = NSArray(array: project.targets)
        let lock = NSRecursiveLock()
        var targetsChecksums = [TargetChecksum]()
        targets.enumerateObjects(options: .concurrent) { (obj, key, stop) in
            if let target = obj as? PBXTarget {
                if let targetChecksum = try? calculateChecksum(for: target, sourceRoot: sourceRoot) {
                    lock.lock()
                    targetsChecksums.append(targetChecksum)
                    lock.unlock()
                }
            }
        }
        let checksum = try targetsChecksums.checksum()
        return ProjectChecksum(
            targets: targetsChecksums,
            checksum: checksum
        )
    }
    
    private func calculateChecksum(
        for target: PBXTarget,
        sourceRoot: Path) throws -> TargetChecksum
    {
        let filesChecksums = try target.fileElement().map { file in
            try calculateChecksum(for: file, sourceRoot: sourceRoot)
        }
        let checksum = try filesChecksums.checksum()
        return TargetChecksum(
            files: filesChecksums,
            checksum: checksum
        )
    }
    
    private func calculateChecksum(
        for file: PBXFileElement,
        sourceRoot: Path) throws -> FileChecksum
    {
        let filePath = try obtainPath(for: file, sourceRoot: sourceRoot)
        let checksum = try Data(contentsOf: filePath.url).md5()
        return FileChecksum(
            filePath: filePath.string,
            checksum: checksum
        )
    }
    
    private func obtainPath(for file: PBXFileElement, sourceRoot: Path) throws -> Path {
        guard let filePath = try file.fullPath(sourceRoot: sourceRoot) else {
            throw ProjectChecksumCalculatorError.emptyFullFilePath(
                name: file.name,
                path: file.path
            )
        }
        return filePath
    }

}

extension PBXTarget {
    func fileElement() -> [PBXFileElement] {
        var files = [PBXFileElement]()
        if let sourcesBuildPhase = try? sourcesBuildPhase(),
            let sourcesFileElement = sourcesBuildPhase?.fileElement() {
            files.append(contentsOf: sourcesFileElement)
        }
        if let resourcesBuildPhase = try? resourcesBuildPhase(),
            let resourcesFileElement = resourcesBuildPhase?.fileElement()  {
            files.append(contentsOf: resourcesFileElement)
        }
        return files
    }
}

extension PBXBuildPhase {
    func fileElement() -> [PBXFileElement] {
        return files.compactMap { $0.file }
    }
}
