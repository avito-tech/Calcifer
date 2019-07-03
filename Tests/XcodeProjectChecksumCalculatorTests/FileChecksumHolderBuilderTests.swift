import Foundation
import XCTest
@testable import XcodeProjectChecksumCalculator
import XcodeProj
import PathKit
import Checksum

public final class FileChecksumHolderBuilderTests: XCTestCase {
    
    let checksumProducer = TestURLChecksumProducer()
    lazy var builder = FileChecksumHolderBuilder(
        checksumProducer: checksumProducer,
        fullPathProvider: TestFileElementFullPathProvider()
    )
    
    // MARK: - Lifecycle
    override public func setUp() {
        super.setUp()
    }
    
    override public func tearDown() {
        super.tearDown()
    }
    
    func test_build_correctly() {
        let filePathString = "file.swift"
        let fileElement = PBXFileElement(path: filePathString)
        let sourceRoot = Path("/")
        let filePath = (sourceRoot + Path(filePathString))
        
        
        let parent = BaseChecksumHolder<TestChecksum>(name: "", parent: nil)
        let targetChecksumHolder = TargetChecksumHolder(
            targetName: "",
            productName: "",
            productType: .framework,
            parent: parent
        )
        
        let checksumHolder = try? builder.build(
            parent: targetChecksumHolder,
            file: fileElement,
            sourceRoot: sourceRoot
        )
        let checksum = try? checksumHolder?.obtainChecksum(checksumProducer: checksumProducer)
        
        XCTAssertEqual(checksum?.stringValue, filePath.url.absoluteString)
        XCTAssertEqual(checksumHolder?.description, filePath.string)
    }

}
