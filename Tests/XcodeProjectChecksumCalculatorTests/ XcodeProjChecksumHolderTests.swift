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
    private let calculator = ConcurentUpToDownChecksumCalculator()
    private let checksumHolderValidator: ChecksumHolderValidator = ChecksumHolderValidatorImpl()
    private lazy var xcodeProjGenerator = XcodeProjGenerator(fileManager: fileManager)
    
    private func prepareChecksumHolder() throws -> XcodeProjChecksumHolder<BaseChecksum> {
        let xcodeProj = try xcodeProjGenerator.generateXcodeProj(
            projectPath: projectPath,
            sourceRoot: sourceRoot,
            fileCount: 30,
            targetCount: 50,
            targetLevelCount: 5
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
        return holder
    }
    
    func test_checksumHolder_valid() {
        assertNoThrow {
            // Given
            let xcodeProj = try xcodeProjGenerator.generateXcodeProj(
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
            _ = try calculator.calculate(rootHolder: holder)
            // Then
            try checksumHolderValidator.validate(holder)
        }
    }
    
    func test_sourceRoot_doesnt_affect_checksum() {
        assertNoThrow {
            // Given
            let firstSourceRoot = sourceRoot.appendingPathComponent(UUID().uuidString)
            let firstProjectPath = firstSourceRoot
                .appendingPathComponent("Pods")
                .appendingPathComponent("Pods.xcodeproj")
            try fileManager.createDirectory(
                atPath: firstSourceRoot,
                withIntermediateDirectories: true
            )
            let firstChecksum = try obtainChecksum(
                projectPath: firstProjectPath,
                sourceRoot: firstSourceRoot
            )
            let secondSourceRoot = sourceRoot.appendingPathComponent(UUID().uuidString)
            let secondProjectPath = secondSourceRoot
                .appendingPathComponent("Pods")
                .appendingPathComponent("Pods.xcodeproj")
            try fileManager.createDirectory(
                atPath: secondSourceRoot,
                withIntermediateDirectories: true
            )
            let secondChecksum = try obtainChecksum(
                projectPath: secondProjectPath,
                sourceRoot: secondSourceRoot
            )
            // Then
            XCTAssertEqual(firstChecksum, secondChecksum)
        }
    }
    
    func test_checksumHolder_smart_and_simple_checksum_calculation_have_the_same_result() {
        assertNoThrow {
            // Given
            let xcodeProj = try xcodeProjGenerator.generateXcodeProj(
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
            let smartChecksum = try calculator.calculate(rootHolder: holder)
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
            let xcodeProj = try xcodeProjGenerator.generateXcodeProj(
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
            let smartChecksum = try calculator.calculate(rootHolder: holder)
            try checksumHolderValidator.validate(holder)
            invalide(holder)
            let checksum = try holder.obtainChecksum()
            
            var leafs = [PBXTarget]()
            let project = xcodeProj.pbxproj.projects.first.unwrapOrFail()
            let rootTarget = project.targets.first.unwrapOrFail()
            rootTarget.leafDependency(leafs: &leafs)
            let leafTarget = leafs.first.unwrapOrFail()
            try xcodeProjGenerator.generateFile(
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
            let newSmartChecksum = try calculator.calculate(rootHolder: holder)
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
            let xcodeProj = try xcodeProjGenerator.generateXcodeProj(
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
            let checksum = try calculator.calculate(rootHolder: holder)
            try checksumHolderValidator.validate(holder)
            
            var leafs = [PBXTarget]()
            let project = xcodeProj.pbxproj.projects.first.unwrapOrFail()
            let rootTarget = project.targets.first.unwrapOrFail()
            rootTarget.leafDependency(leafs: &leafs)
            let leafTarget = leafs.first.unwrapOrFail()
            let newFile = try xcodeProjGenerator.generateFile(
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
            let checksumAfterAdd = try calculator.calculate(rootHolder: holder)
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
            let checksumAfterRemove = try calculator.calculate(rootHolder: holder)
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
                let xcodeProj = try xcodeProjGenerator.generateXcodeProj(
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
                let smartChecksum = try calculator.calculate(rootHolder: holder)
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
    
    private func obtainChecksum(
        projectPath: String,
        sourceRoot: String)
        throws -> String
    {
        let xcodeProj = try xcodeProjGenerator.generateXcodeProj(
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
        let checksum = try calculator.calculate(rootHolder: holder)
        try checksumHolderValidator.validate(holder)
        return checksum.stringValue
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
