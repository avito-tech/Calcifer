import Foundation
import XCTest
@testable import XcodeProjectChecksumCalculator
import XcodeProj
import PathKit
import Checksum
import Toolkit

public final class FileChecksumHolderTests: XCTestCase {
    
    let checksumProducer = TestURLChecksumProducer()
    let fullPathProvider = TestFileElementFullPathProvider()
    
    // MARK: - Lifecycle
    override public func setUp() {
        super.setUp()
    }
    
    override public func tearDown() {
        super.tearDown()
    }
    
    func test_build_correctly() {
        // Given
        let filePathString = "file.swift"
        let fileElement = PBXFileElement(path: filePathString)
        let sourceRoot = Path("/")
        let filePath = (sourceRoot + Path(filePathString))
        let parent = BaseChecksumHolder<TestChecksum>(name: "", parent: nil)
        let checksumHolder = FileChecksumHolder(
            fileURL: filePath.url,
            parent: parent,
            checksumProducer: checksumProducer
        )
        // When
        let checksum = try? checksumHolder.obtainChecksum()
        // Then
        XCTAssertEqual(checksum?.stringValue, filePath.url.absoluteString)
    }

}
