import Foundation
import XCTest
import Checksum
import XcodeProjectChecksumCalculator
import Mock
@testable import BuildArtifacts

public final class TargetBuildArtifactMetaInfoManagerImplTests: XCTestCase {
    
    private let artifactsDirectoryPath = NSTemporaryDirectory().appendingPathComponent("test_artifacts")
    private let fileManager = FileManager.default
    
    override public func setUp() {
        super.setUp()
        try? fileManager.removeItem(atPath: artifactsDirectoryPath)
    }
    
    override public func tearDown() {
        super.tearDown()
        try? fileManager.removeItem(atPath: artifactsDirectoryPath)
    }
    
    func test_write() {
        assertNoThrow {
            // Given
            let manager = TargetBuildArtifactMetaInfoManagerImpl(fileManager: fileManager)
            let checksum = BaseChecksum(UUID().uuidString)
            let metaInfo = TargetBuildArtifactMetaInfo(checksum: checksum)
            let artifactURL = URL(
                fileURLWithPath: artifactsDirectoryPath.appendingPathComponent(UUID().uuidString)
            )
            try fileManager.createDirectory(
                at: artifactURL,
                withIntermediateDirectories: true
            )
            // When
            try manager.write(metaInfo: metaInfo, artifactURL: artifactURL)
            let resultMetaInfo = try manager.readMetaInfo(artifactURL: artifactURL)
            // Then
            XCTAssertEqual(resultMetaInfo?.checksum, metaInfo.checksum)
        }
    }
    
}
