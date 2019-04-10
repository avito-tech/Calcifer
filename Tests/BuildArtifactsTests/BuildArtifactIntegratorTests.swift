import Foundation
import XCTest
import Checksum
import XcodeProjectChecksumCalculator
@testable import BuildArtifacts

public final class BuildArtifactIntegratorTests: XCTestCase {
    
    private let artifactsDirectoryPath = NSTemporaryDirectory().appendingPathComponent("test_artifacts")
    private let artifactsDestination = NSTemporaryDirectory().appendingPathComponent("test_destination")
    private let fileManager = FileManager.default
    
    override public func setUp() {
        super.setUp()
        try? fileManager.removeItem(atPath: artifactsDirectoryPath)
        try? fileManager.removeItem(atPath: artifactsDestination)
    }
    
    override public func tearDown() {
        super.tearDown()
        try? fileManager.removeItem(atPath: artifactsDirectoryPath)
        try? fileManager.removeItem(atPath: artifactsDestination)
    }
    
    func test_obtainArtifacts() {
        XCTAssertNoThrow(try {
            // Given
            let checksumProducer = BaseURLChecksumProducer(fileManager: fileManager)
            let integrator = BuildArtifactIntegrator(fileManager: fileManager, checksumProducer: checksumProducer)
            let targetInfo = TargetInfo(
                targetName: "Some",
                productName: "Some.framework",
                productType: .framework,
                dependencies: [],
                checksum: BaseChecksum(UUID().uuidString)
            )
            try ArtifactFileBuilder().createArtifactFile(
                fileManager: fileManager,
                targetInfo: targetInfo,
                at: artifactsDirectoryPath
            )
            let artifacts = [
                ProductBuildArtifact(
                    targetInfo: targetInfo,
                    path: artifactsDirectoryPath
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
        }(), "Caught exception")
    }
    
    private func obtainExpectedPath(
        for targetInfo: TargetInfo<BaseChecksum>)
        -> String
    {
        return artifactsDestination.appendingPathComponent(targetInfo.targetName)
    }

}
