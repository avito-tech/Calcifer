import Foundation
@testable import XcodeProj
import PathKit

public final class XcodeProjGenerator {
    
    private let fileManager: FileManager
    
    public init(fileManager: FileManager) {
        self.fileManager = fileManager
    }
    
    public func generateXcodeProj(
        projectPath: String,
        sourceRoot: String,
        fileCount: Int = 10,
        targetCount: Int = 10,
        targetLevelCount: Int = 1)
        throws -> XcodeProj
    {
        let sourceRootPath = Path(sourceRoot)
        let workspace = XCWorkspace()
        let mainGroup = PBXGroup.fixture()
        let project = PBXProject.fixture(mainGroup: mainGroup)
        let pbxproj = PBXProj.fixture(rootObject: project)
        pbxproj.add(object: project)
        pbxproj.add(object: mainGroup)
        let xcodeProj = XcodeProj(workspace: workspace, pbxproj: pbxproj)
        
        let mainTarget = try generateTarget(
            name: "root",
            pbxproj: pbxproj,
            project: project,
            sourceRoot: sourceRootPath,
            fileCount: fileCount
        )
        
        var dependencyTargets = [PBXTarget]()
        for i in (0...targetCount) {
            let levelRootTarget = try generateTarget(
                name: "\(i)",
                pbxproj: pbxproj,
                project: project,
                sourceRoot: sourceRootPath,
                fileCount: fileCount
            )
            var previousLevelTarget = levelRootTarget
            for level in (0...targetLevelCount) {
                let target = try generateTarget(
                    name: "\(i)-\(level)",
                    pbxproj: pbxproj,
                    project: project,
                    sourceRoot: sourceRootPath,
                    fileCount: fileCount
                )
                addDependencies(
                    to: previousLevelTarget,
                    pbxproj: pbxproj,
                    dependencyTargets: [target]
                )
                previousLevelTarget = target
            }
            dependencyTargets.append(levelRootTarget)
        }
        addDependencies(
            to: mainTarget,
            pbxproj: pbxproj,
            dependencyTargets: dependencyTargets
        )
        
        try fileManager.createDirectory(
            atPath: projectPath,
            withIntermediateDirectories: true
        )
        try xcodeProj.write(path: Path(projectPath))
        return xcodeProj
    }
    
    public func generateTarget(
        name: String,
        pbxproj: PBXProj,
        project: PBXProject,
        sourceRoot: Path,
        fileCount: Int,
        dependencyTargets: [PBXTarget] = [])
        throws -> PBXTarget
    {
        let buildPhase = PBXSourcesBuildPhase.fixture(files: [])
        pbxproj.add(object: buildPhase)
        let target = PBXNativeTarget(name: name)
        target.buildPhases.append(buildPhase)
        project.targets.append(target)
        pbxproj.add(object: target)
        
        for i in (0...fileCount) {
            try generateFile(
                name: "\(name)-\(i)",
                target: target,
                sourceRoot: sourceRoot,
                project: project
            )
        }
        
        addDependencies(
            to: target,
            pbxproj: pbxproj,
            dependencyTargets: dependencyTargets
        )
        
        return target
    }
    
    func addDependencies(to target: PBXTarget, pbxproj: PBXProj, dependencyTargets: [PBXTarget]) {
        for dependencyTarget in dependencyTargets {
            let dependency = PBXTargetDependency(
                name: dependencyTarget.name,
                target: dependencyTarget
            )
            pbxproj.add(object: dependency)
            target.dependencies.append(dependency)
        }
    }
    
    @discardableResult
    public func generateFile(
        name: String,
        target: PBXTarget,
        sourceRoot: Path,
        project: PBXProject)
        throws -> PBXBuildFile
    {
        let filePath = Path("\(name).swift")
        let fullFilePath = (sourceRoot + filePath)
        let content = "struct \(name) {}".data(using: .utf8).unwrapOrFail()
        fileManager.createFile(
            atPath: fullFilePath.url.path,
            contents: content
        )
        let fileReference = try project.mainGroup.addFile(
            at: fullFilePath,
            sourceRoot: sourceRoot
        )
        let sourcesBuildPhase = try target.sourcesBuildPhase().unwrapOrFail()
        return try sourcesBuildPhase.add(file: fileReference)
    }
}
