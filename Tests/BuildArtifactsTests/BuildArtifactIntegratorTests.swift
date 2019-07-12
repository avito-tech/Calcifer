import Foundation
import XCTest
import Checksum
import XcodeProjectChecksumCalculator
import Mock
@testable import BuildArtifacts

public final class BuildArtifactIntegratorTests: BaseTestCase {
    
    private lazy var artifactsDirectoryPath = createTmpDirectory()
        .appendingPathComponent("test_artifacts").path
    private lazy var artifactsDestination = createTmpDirectory()
        .appendingPathComponent("test_destination").path
    
    func test_obtainArtifacts() {
        assertNoThrow {
            // Given
            let checksumProducer = BaseURLChecksumProducer(fileManager: fileManager)
            let targetBuildArtifactMetaInfoManager = TargetBuildArtifactMetaInfoManagerStub()
            let integrator = BuildArtifactIntegrator(
                fileManager: fileManager,
                checksumProducer: checksumProducer,
                targetBuildArtifactMetaInfoManager: targetBuildArtifactMetaInfoManager)
            let targetInfo = TargetInfo(
                targetName: "Some",
                productName: "Some.framework",
                productType: .framework,
                dependencies: [],
                checksum: BaseChecksum(uuid)
            )
            try ArtifactFileBuilder().createArtifactFile(
                fileManager: fileManager,
                targetInfo: targetInfo,
                at: artifactsDirectoryPath
            )
            let productPath = artifactsDirectoryPath
                .appendingPathComponent(targetInfo.productName.deletingPathExtension())
                .appendingPathComponent(targetInfo.productName)
            var dsymPath = artifactsDirectoryPath
                .appendingPathComponent(targetInfo.productName.deletingPathExtension())
                .appendingPathComponent(targetInfo.productName)
            dsymPath.append(".dSYM")
            let artifacts = [
                TargetBuildArtifact(
                    targetInfo: targetInfo,
                    productPath: productPath,
                    dsymPath: dsymPath
                )
            ]
            let expectedPath = obtainExpectedPath(for: targetInfo)

            // When
            try integrator.integrate(
                artifacts: artifacts,
                to: artifactsDestination
            )

            // Then
            XCTAssertTrue(fileManager.directoryExist(at: expectedPath))
        }
    }
    
    private func obtainExpectedPath(
        for targetInfo: TargetInfo<BaseChecksum>)
        -> String
    {
        return artifactsDestination.appendingPathComponent(targetInfo.targetName)
    }

}
