import Foundation
import XCTest
import Checksum
@testable import BuildProductCacheStorage

public final class LocalBuildProductCacheStorageTests: XCTestCase {
    
    private let cacheDirectoryPath = NSTemporaryDirectory().appendingPathComponent("test")
    private let fileManager = FileManager.default
    
    override public func setUp() {
        super.setUp()
        try? fileManager.removeItem(atPath: cacheDirectoryPath)
    }
    
    override public func tearDown() {
        super.tearDown()
        try? fileManager.removeItem(atPath: cacheDirectoryPath)
    }
    
    func test_addCache() {
        // Given
        let storage = LocalBuildProductCacheStorage<BaseChecksum>(
            fileManager: fileManager,
            cacheDirectoryPath: cacheDirectoryPath
        )
        let cacheKey = BuildProductCacheKey(
            productName: "Some.framework",
            productType: .framework,
            checksum: BaseChecksum(UUID().uuidString)
        )
        let frameworkContainingFolderPath = createArtifactFile(
            fileManager: fileManager,
            cacheKey: cacheKey
        )
        let expectedPath = obtainExpectedPath(for: cacheKey)
        
        // When
        storage.add(
            cacheKey: cacheKey,
            at: frameworkContainingFolderPath)
        {
                storage.cached(for: cacheKey) { [weak self] result in
                    // Then
                    switch result {
                    case let .result(value):
                        XCTAssertTrue(self?.fileManager.directoryExist(at: expectedPath) ?? false)
                        XCTAssertEqual(value.path, expectedPath)
                    case .notExist:
                        XCTFail("Failed add cache")
                    }
                }
        }
    }
    
    private func createArtifactFile(
        fileManager: FileManager,
        cacheKey: BuildProductCacheKey<BaseChecksum>)
        -> String
    {
        let currentPath = cacheDirectoryPath.appendingPathComponent("Debug-iphoneos")
        let frameworkContainingFolderPath = currentPath.appendingPathComponent(cacheKey.productName)
        let frameworkPath = frameworkContainingFolderPath.appendingPathComponent("\(cacheKey.productName).framework")
        do {
            try fileManager.createDirectory(
                atPath: frameworkContainingFolderPath,
                withIntermediateDirectories: true
            )
            fileManager.createFile(
                atPath: frameworkPath,
                contents: Data(base64Encoded: UUID().uuidString)
            )
            return frameworkContainingFolderPath
        } catch {
            XCTFail("Failed create artifact file")
            return ""
        }
    }
    
    private func obtainExpectedPath(for cacheKey: BuildProductCacheKey<BaseChecksum>) -> String {
         return cacheDirectoryPath
            .appendingPathComponent(cacheKey.productType.rawValue)
            .appendingPathComponent(cacheKey.productName.deletingPathExtension())
            .appendingPathComponent(cacheKey.checksum.stringValue)
            .appendingPathComponent(cacheKey.productName)
    }

}
