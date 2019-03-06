import Foundation
import XCTest
@testable import ProjectChecksumCalculator
@testable import xcodeproj
import PathKit
import Toolkit

public final class TargetChecksumHolderBuilderTests: XCTestCase {
    
    let builder = TargetChecksumHolderBuilder(
        builder: FileChecksumHolderBuilder(
            checksumProducer: TestURLChecksumProducer(),
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
        let expectedChecksum = target.filesPathes(sourceRoot: sourceRoot)
        let checksumHolder = try? builder.build(
            target: target,
            sourceRoot: sourceRoot,
            cacheReader: cache.read,
            cacheWriter: cache.write
        )
        
        XCTAssertEqual(checksumHolder?.checksum.stringValue, expectedChecksum)
        XCTAssertEqual(checksumHolder?.description, target.name)
    }
    
    func test_build_correctly_withDependency() {
        let target = PBXObjectFactory.target()
        let targetWithDependencies = PBXObjectFactory.target(
            dependencies: [target]
        )
        let cache = ThreadSafeDictionary<PBXTarget, TargetChecksumHolder<TestChecksum>>()
        let sourceRoot = Path("/")
        let filesPathes = targetWithDependencies.filesPathes(sourceRoot: sourceRoot)
        let expectedChecksum = target.filesPathes(sourceRoot: sourceRoot) + filesPathes

        let checksumHolder = try? builder.build(
            target: targetWithDependencies,
            sourceRoot: sourceRoot,
            cacheReader: cache.read,
            cacheWriter: cache.write
        )

        XCTAssertEqual(checksumHolder?.checksum.stringValue, expectedChecksum)
        XCTAssertEqual(checksumHolder?.description, targetWithDependencies.name)
    }
    
}
