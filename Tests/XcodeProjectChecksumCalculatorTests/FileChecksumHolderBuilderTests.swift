import Foundation
import XCTest
@testable import XcodeProjectChecksumCalculator
import xcodeproj
import PathKit

public final class FileChecksumHolderBuilderTests: XCTestCase {
    
    let builder = FileChecksumHolderBuilder(
        checksumProducer: TestURLChecksumProducer(),
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
        
        let checksumHolder = try? builder.build(
            file: fileElement,
            sourceRoot: sourceRoot
        )
        
        XCTAssertEqual(checksumHolder?.checksum.stringValue, filePath.url.absoluteString)
        XCTAssertEqual(checksumHolder?.description, filePath.string)
    }

}
