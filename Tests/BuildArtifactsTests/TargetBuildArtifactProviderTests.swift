import Foundation
import XCTest
import Checksum
import Mock
import XcodeProjectChecksumCalculator
@testable import BuildArtifacts

public final class TargetBuildArtifactProviderTests: BaseTestCase {
    
    private lazy var artifactsDirectoryPath = createTmpDirectory()
        .appendingPathComponent("test_artifacts").path
    
    func test_obtainArtifacts() {
        assertNoThrow {
            // Given
            let provider = TargetBuildArtifactProvider(fileManager: fileManager)
            let targetInfo = TargetInfo(
                targetName: "Some",
                productName: "Some.framework",
                productType: .framework,
                dependencies: [],
                checksum: BaseChecksum(uuid)
            )
            let expectedPath = try ArtifactFileBuilder().createArtifactFile(
                fileManager: fileManager,
                targetInfo: targetInfo,
                at: artifactsDirectoryPath
            )
            
            // When
            let artifacts = try provider.artifacts(
                for: [targetInfo],
                at: artifactsDirectoryPath,
                dSYMShouldExist: true
            )
            
            // Then
            XCTAssertEqual(artifacts.first?.productPath, expectedPath)
        }
    }

}
