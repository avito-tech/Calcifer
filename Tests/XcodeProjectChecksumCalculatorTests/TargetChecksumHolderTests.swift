import Foundation
import XCTest
@testable import XcodeProjectChecksumCalculator
@testable import XcodeProj
import PathKit
import Toolkit
import Checksum

public final class TargetChecksumHolderTests: XCTestCase {
    
    let checksumProducer = TestURLChecksumProducer()
    let fullPathProvider = TestFileElementFullPathProvider()
    let objectFactory = PBXObjectFactory(objects: PBXObjects())
    
    func test_build_correctly() {
        // Given
        let target = objectFactory.target()
        let targetCache = ThreadSafeDictionary<String, TargetChecksumHolder<TestChecksum>>()
        let fileCache = ThreadSafeDictionary<String, FileChecksumHolder<TestChecksum>>()
        let sourceRoot = Path("/")
        let expectedChecksum = target.filesPaths(sourceRoot: sourceRoot)
        let parent = BaseChecksumHolder<TestChecksum>(name: "", parent: nil)
        let updateModel = TargetUpdateModel(
            target: target,
            sourceRoot: sourceRoot,
            targetCache: targetCache,
            fileCache: fileCache)
        let checksumHolder = TargetChecksumHolder(
            updateModel: updateModel,
            parent: parent,
            fullPathProvider: fullPathProvider,
            checksumProducer: checksumProducer
        )
        try? checksumHolder.reflectUpdate(updateModel: updateModel)
        // When
        let checksum = try? checksumHolder.obtainChecksum()
        // Then
        XCTAssertEqual(checksum?.stringValue, expectedChecksum)
        XCTAssertEqual(checksumHolder.targetName, target.name)
    }
    
    func test_build_correctly_withDependency() {
        let target = objectFactory.target(name: "a")
        let targetWithDependencies = objectFactory.target(
            dependencies: [target]
        )
        let targetCache = ThreadSafeDictionary<String, TargetChecksumHolder<TestChecksum>>()
        let fileCache = ThreadSafeDictionary<String, FileChecksumHolder<TestChecksum>>()
        let sourceRoot = Path("/")
        let targetFiles = target.filesPaths(sourceRoot: sourceRoot)
        let targetWithDependenciesFiles = targetWithDependencies.filesPaths(sourceRoot: sourceRoot)
        let expectedChecksum = [
            targetWithDependenciesFiles,
            targetFiles
        ].joined()
        
        let parent = BaseChecksumHolder<TestChecksum>(name: "", parent: nil)
        let targetWithDependenciesUpdateModel = TargetUpdateModel(
            target: targetWithDependencies,
            sourceRoot: sourceRoot,
            targetCache: targetCache,
            fileCache: fileCache
        )
        let targetWithDependenciesChecksumHolder = TargetChecksumHolder(
            updateModel: targetWithDependenciesUpdateModel,
            parent: parent,
            fullPathProvider: fullPathProvider,
            checksumProducer: checksumProducer
        )
        let targetUpdateModel = TargetUpdateModel(
            target: target,
            sourceRoot: sourceRoot,
            targetCache: targetCache,
            fileCache: fileCache
        )
        let targetChecksumHolder = TargetChecksumHolder(
            updateModel: targetUpdateModel,
            parent: targetWithDependenciesChecksumHolder,
            fullPathProvider: fullPathProvider,
            checksumProducer: checksumProducer
        )
        targetCache.write(targetChecksumHolder, for: targetUpdateModel.name)
        try? targetChecksumHolder.reflectUpdate(
            updateModel: targetUpdateModel
        )
        try? targetWithDependenciesChecksumHolder.reflectUpdate(
            updateModel: targetWithDependenciesUpdateModel
        )
        // When
        let targetWithDependenciesChecksum = try? targetWithDependenciesChecksumHolder.obtainChecksum()
        // Then
        XCTAssertEqual(targetWithDependenciesChecksum?.stringValue, expectedChecksum)
    }
    
}
