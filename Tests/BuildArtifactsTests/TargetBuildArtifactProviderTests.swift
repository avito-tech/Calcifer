import Foundation
import XCTest
import Checksum
import XcodeProjectChecksumCalculator
@testable import BuildArtifacts

public final class TargetBuildArtifactProviderTests: XCTestCase {
    
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
    
    func test_obtainArtifacts() {
        // Given
        let provider = TargetBuildArtifactProvider(fileManager: fileManager)
        let targetInfo = TargetInfo(
            targetName: "Some",
            productName: "Some.framework",
            productType: .framework,
            dependencies: [],
            checksum: BaseChecksum(UUID().uuidString)
        )
        let expectedPath = try? ArtifactFileBuilder().createArtifactFile(
            fileManager: fileManager,
            targetInfo: targetInfo,
            at: artifactsDirectoryPath
        )
        
        // When
        let artifacts = try? provider.artifacts(for: [targetInfo], at: artifactsDirectoryPath)
        
        // Then
        XCTAssertEqual(artifacts?.first?.productPath, expectedPath)
    }

}
