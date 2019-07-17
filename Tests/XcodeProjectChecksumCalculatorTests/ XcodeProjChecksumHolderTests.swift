import Foundation
import XCTest
import Mock
@testable import XcodeProjectChecksumCalculator
@testable import XcodeProj
import PathKit
import Toolkit
import Checksum

public final class XcodeProjChecksumHolderTests: BaseTestCase {
    
    private lazy var sourceRoot = createTmpDirectory().path
    private lazy var projectPath = sourceRoot
        .appendingPathComponent("Pods")
        .appendingPathComponent("Pods.xcodeproj")
    
    private lazy var fullPathProvider = BaseFileElementFullPathProvider()
    private lazy var checksumProducer = BaseURLChecksumProducer(fileManager: fileManager)
    private lazy var checksumHolderValidator: ChecksumHolderValidator = ChecksumHolderValidatorImpl()
    
    func test_checksumHolder_valid() {
        assertNoThrow {
            // Given
            let xcodeProj = try generateXcodeProj(
                projectPath: projectPath,
                sourceRoot: sourceRoot
            )
            let updateModel = try generateXcodeProjUpdateModel(
                xcodeProj: xcodeProj,
                projectPath: projectPath,
                sourceRoot: sourceRoot
            )
            let holder = XcodeProjChecksumHolder(
                name: projectPath,
                fullPathProvider: fullPathProvider,
                checksumProducer: checksumProducer
            )
            // When
            try holder.reflectUpdate(updateModel: updateModel)
            let _ = try holder.smartChecksumCalculate()
            // Then
            try checksumHolderValidator.validate(holder)
        }
    }
    
    func test_checksumHolder_smart_and_simple_checksum_calculation_have_the_same_result() {
        assertNoThrow {
            // Given
            let xcodeProj = try generateXcodeProj(
                projectPath: projectPath,
                sourceRoot: sourceRoot
            )
            let updateModel = try generateXcodeProjUpdateModel(
                xcodeProj: xcodeProj,
                projectPath: projectPath,
                sourceRoot: sourceRoot
            )
            let holder = XcodeProjChecksumHolder(
                name: projectPath,
                fullPathProvider: fullPathProvider,
                checksumProducer: checksumProducer
            )
            try holder.reflectUpdate(updateModel: updateModel)
            // When
            let smartChecksum = try holder.smartChecksumCalculate()
            try checksumHolderValidator.validate(holder)
            invalide(holder)
            let checksum = try holder.obtainChecksum()
            try checksumHolderValidator.validate(holder)
            // Then
            XCTAssertEqual(smartChecksum, checksum)
        }
    }
    
    func test_checksumHolder_valid_after_update() {
        assertNoThrow {
            // Given
            let xcodeProj = try generateXcodeProj(
                projectPath: projectPath,
                sourceRoot: sourceRoot
            )
            let updateModel = try generateXcodeProjUpdateModel(
                xcodeProj: xcodeProj,
                projectPath: projectPath,
                sourceRoot: sourceRoot
            )
            let holder = XcodeProjChecksumHolder(
                name: projectPath,
                fullPathProvider: fullPathProvider,
                checksumProducer: checksumProducer
            )
            try holder.reflectUpdate(updateModel: updateModel)
            let smartChecksum = try holder.smartChecksumCalculate()
            try checksumHolderValidator.validate(holder)
            invalide(holder)
            let checksum = try holder.obtainChecksum()
            
            var leafs = [PBXTarget]()
            let project = xcodeProj.pbxproj.projects.first.unwrapOrFail()
            let rootTarget = project.targets.first.unwrapOrFail()
            rootTarget.leafDependency(leafs: &leafs)
            let leafTarget = leafs.first.unwrapOrFail()
            try generateFile(
                name: "newLeaf",
                target: leafTarget,
                sourceRoot: Path(sourceRoot),
                project: project
            )
            try xcodeProj.write(path: Path(projectPath))
            let newUpdateModel = try generateXcodeProjUpdateModel(
                xcodeProj: xcodeProj,
                projectPath: projectPath,
                sourceRoot: sourceRoot
            )
            // When
            try holder.reflectUpdate(updateModel: newUpdateModel)
            let newSmartChecksum = try holder.smartChecksumCalculate()
            try checksumHolderValidator.validate(holder)
            invalide(holder)
            let newChecksum = try holder.obtainChecksum()
            try checksumHolderValidator.validate(holder)
            // Then
            XCTAssertNotEqual(newChecksum, checksum)
            XCTAssertNotEqual(newSmartChecksum, smartChecksum)
            XCTAssertEqual(checksum, smartChecksum)
            XCTAssertEqual(newChecksum, newSmartChecksum)
        }
    }
    
    func test_checksumHolder_checksum_same_after_equal_update() {
        assertNoThrow {
            // Given
            let xcodeProj = try generateXcodeProj(
                projectPath: projectPath,
                sourceRoot: sourceRoot
            )
            let updateModel = try generateXcodeProjUpdateModel(
                xcodeProj: xcodeProj,
                projectPath: projectPath,
                sourceRoot: sourceRoot
            )
            let holder = XcodeProjChecksumHolder(
                name: projectPath,
                fullPathProvider: fullPathProvider,
                checksumProducer: checksumProducer
            )
            try holder.reflectUpdate(updateModel: updateModel)
            let checksum = try holder.smartChecksumCalculate()
            try checksumHolderValidator.validate(holder)
            
            var leafs = [PBXTarget]()
            let project = xcodeProj.pbxproj.projects.first.unwrapOrFail()
            let rootTarget = project.targets.first.unwrapOrFail()
            rootTarget.leafDependency(leafs: &leafs)
            let leafTarget = leafs.first.unwrapOrFail()
            let newFile = try generateFile(
                name: "newLeaf",
                target: leafTarget,
                sourceRoot: Path(sourceRoot),
                project: project
            )
            try xcodeProj.write(path: Path(projectPath))
            let updateModelAfterAdd = try generateXcodeProjUpdateModel(
                xcodeProj: xcodeProj,
                projectPath: projectPath,
                sourceRoot: sourceRoot
            )
            try holder.reflectUpdate(updateModel: updateModelAfterAdd)
            let checksumAfterAdd = try holder.smartChecksumCalculate()
            try checksumHolderValidator.validate(holder)
            // When
            xcodeProj.pbxproj.delete(object: newFile)
            try xcodeProj.write(path: Path(projectPath))
            
            let sourcesBuildPhase = try leafTarget.sourcesBuildPhase().unwrapOrFail()
            sourcesBuildPhase.files?.removeAll(where: { $0 == newFile })
            
            try leafTarget.sourcesBuildPhase()?.files?.removeAll(where: { $0 == newFile.file })
            let updateModelAfterRemove = try generateXcodeProjUpdateModel(
                xcodeProj: xcodeProj,
                projectPath: projectPath,
                sourceRoot: sourceRoot
            )
            try holder.reflectUpdate(updateModel: updateModelAfterRemove)
            let checksumAfterRemove = try holder.smartChecksumCalculate()
            try checksumHolderValidator.validate(holder)
            // Then
            XCTAssertNotEqual(checksum, checksumAfterAdd)
            XCTAssertNotEqual(checksumAfterAdd, checksumAfterRemove)
            XCTAssertEqual(checksum, checksumAfterRemove)
        }
    }
    
    func test_checksumHolder_reproducible() {
        assertNoThrow {
            // Given
            var checksums = Set<String>()
            // When
            for _ in (0...10) {
                let xcodeProj = try generateXcodeProj(
                    projectPath: projectPath,
                    sourceRoot: sourceRoot
                )
                let updateModel = try generateXcodeProjUpdateModel(
                    xcodeProj: xcodeProj,
                    projectPath: projectPath,
                    sourceRoot: sourceRoot
                )
                let holder = XcodeProjChecksumHolder(
                    name: projectPath,
                    fullPathProvider: fullPathProvider,
                    checksumProducer: checksumProducer
                )
                try holder.reflectUpdate(updateModel: updateModel)
                let checksum = try holder.obtainChecksum()
                checksums.insert(checksum.stringValue)
                try checksumHolderValidator.validate(holder)
                invalide(holder)
                let smartChecksum = try holder.smartChecksumCalculate()
                checksums.insert(smartChecksum.stringValue)
                try checksumHolderValidator.validate(holder)
                try fileManager.removeItem(atPath: sourceRoot)
                try fileManager.createDirectory(
                    atPath: sourceRoot,
                    withIntermediateDirectories: true
                )
            }
            // Then
            XCTAssertEqual(checksums.count, 1)
        }
    }
    
    private func generateXcodeProj(
        projectPath: String,
        sourceRoot: String,
        fileCount: Int = 10,
        targetCount: Int = 10)
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
        
        var dependencyTargets = [mainTarget]
        for i in (0...targetCount) {
            let target = try generateTarget(
                name: "\(i)",
                pbxproj: pbxproj,
                project: project,
                sourceRoot: sourceRootPath,
                fileCount: fileCount,
                dependencyTargets: dependencyTargets
            )
            dependencyTargets.append(target)
        }

        try fileManager.createDirectory(
            atPath: projectPath,
            withIntermediateDirectories: true
        )
        try xcodeProj.write(path: Path(projectPath))
        return xcodeProj
    }
    
    private func generateTarget(
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

        
        for dependencyTarget in dependencyTargets {
            let dependency = PBXTargetDependency(
                name: dependencyTarget.name,
                target: dependencyTarget
            )
            pbxproj.add(object: dependency)
            target.dependencies.append(dependency)
        }
        
        return target
    }
    
    @discardableResult
    private func generateFile(
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
    
    private func generateXcodeProjUpdateModel(
        xcodeProj: XcodeProj,
        projectPath: String,
        sourceRoot: String)
        throws -> XcodeProjUpdateModel
    {
        let model = XcodeProjUpdateModel(
            xcodeProj: xcodeProj,
            projectPath: projectPath,
            sourceRoot: Path(sourceRoot)
        )
        return model
    }
    
    private func invalide<ChecksumType: Checksum>(_ holder: BaseChecksumHolder<ChecksumType>) {
        performForLeafChecksumHolder(for: holder) { leafHolder in
            leafHolder.invalidate()
        }
    }
    
    private func performForLeafChecksumHolder<ChecksumType: Checksum>(
        for checksumHolder: BaseChecksumHolder<ChecksumType>,
        closure: (BaseChecksumHolder<ChecksumType>) -> ())
    {
        if checksumHolder.children.isEmpty {
            closure(checksumHolder)
        }
        for child in checksumHolder.children.values {
            performForLeafChecksumHolder(
                for: child,
                closure: closure
            )
        }
    }
    
}

extension PBXTarget {
    func leafDependency(leafs: inout [PBXTarget]) {
        if dependencies.isEmpty {
            leafs.append(self)
            return
        }
        dependencies.compactMap { $0.target }.forEach { $0.leafDependency(leafs: &leafs) }
    }
}
