import Foundation
import XCTest
@testable import XcodeProjectChecksumCalculator
@testable import XcodeProj
import PathKit
import Toolkit
import Checksum

public final class TargetChecksumHolderBuilderTests: XCTestCase {
    
    let checksumProducer = TestURLChecksumProducer()
    lazy var builder = TargetChecksumHolderBuilder(
        builder: FileChecksumHolderBuilder(
            checksumProducer: checksumProducer,
            fullPathProvider: TestFileElementFullPathProvider()
        )
    )
    
    // MARK: - Lifecycle
    override public func setUp() {
        super.setUp()
        let objects = PBXObjects()
        PBXObjectFactory.objects = objects
    }
    
    override public func tearDown() {
        super.tearDown()
        PBXObjectFactory.objects = nil
    }
    
    func test_build_correctly() {
        let target = PBXObjectFactory.target()
        let cache = ThreadSafeDictionary<PBXTarget, TargetChecksumHolder<TestChecksum>>()
        let sourceRoot = Path("/")
        let expectedChecksum = target.filesPaths(sourceRoot: sourceRoot)
        let parent = BaseChecksumHolder<TestChecksum>(name: "", parent: nil)
        let checksumHolder = try? builder.build(
            parent: parent,
            target: target,
            sourceRoot: sourceRoot,
            cache: cache
        )
        let checksum = try? checksumHolder?.obtainChecksum(checksumProducer: checksumProducer)
        XCTAssertEqual(checksum?.stringValue, expectedChecksum)
        XCTAssertEqual(checksumHolder?.targetName, target.name)
    }
    
    func test_build_correctly_withDependency() {
        let target = PBXObjectFactory.target()
        let targetWithDependencies = PBXObjectFactory.target(
            dependencies: [target]
        )
        let cache = ThreadSafeDictionary<PBXTarget, TargetChecksumHolder<TestChecksum>>()
        let sourceRoot = Path("/")
        let filesPaths = targetWithDependencies.filesPaths(sourceRoot: sourceRoot)
        let expectedChecksum = [
            target.filesPaths(sourceRoot: sourceRoot),
            filesPaths
        ].sorted().joined()
        
        let parent = BaseChecksumHolder<TestChecksum>(name: "", parent: nil)
        let checksumHolder = try? builder.build(
            parent: parent,
            target: targetWithDependencies,
            sourceRoot: sourceRoot,
            cache: cache
        )
        let checksum = try? checksumHolder?.obtainChecksum(checksumProducer: checksumProducer)
        
        XCTAssertEqual(checksum?.stringValue, expectedChecksum)
        XCTAssertEqual(checksumHolder?.targetName, targetWithDependencies.name)
    }
    
}
