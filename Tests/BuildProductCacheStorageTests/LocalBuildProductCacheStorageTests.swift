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
        XCTAssertNoThrow(try {
            // Given
            let storage = LocalBuildProductCacheStorage<BaseChecksum>(
                fileManager: fileManager,
                cacheDirectoryPath: cacheDirectoryPath
            )
            let cacheKey = BuildProductCacheKey(
                productName: "Some",
                productType: .framework,
                checksum: BaseChecksum(UUID().uuidString)
            )
            let frameworkContainingFolderPath = try createArtifactFile(
                fileManager: fileManager,
                cacheKey: cacheKey
            )
            let expectedPath = obtainExpectedPath(for: cacheKey)
            
            // When
            try storage.add(cacheKey: cacheKey, at: frameworkContainingFolderPath)
            guard let optionalValue = try? storage.cached(for: cacheKey),
                let value = optionalValue
                else {
                XCTFail("Empty cache value")
                return
            }

            // Then
            XCTAssertTrue(fileManager.directoryExist(at: expectedPath))
            XCTAssertEqual(value.path, expectedPath)
        }(), "Caught exception")
    }
    
    private func createArtifactFile(
        fileManager: FileManager,
        cacheKey: BuildProductCacheKey<BaseChecksum>)
        throws -> String
    {
        let currentPath = cacheDirectoryPath.appendingPathComponent("Debug-iphoneos")
        let frameworkContainingFolderPath = currentPath.appendingPathComponent(cacheKey.productName)
        let frameworkPath = frameworkContainingFolderPath.appendingPathComponent("\(cacheKey.productName).framework")
        try fileManager.createDirectory(
            atPath: frameworkContainingFolderPath,
            withIntermediateDirectories: true
        )
        fileManager.createFile(
            atPath: frameworkPath,
            contents: Data(base64Encoded: UUID().uuidString)
        )
        return frameworkContainingFolderPath
    }
    
    private func obtainExpectedPath(for cacheKey: BuildProductCacheKey<BaseChecksum>) -> String {
         return cacheDirectoryPath
            .appendingPathComponent(cacheKey.productType.rawValue)
            .appendingPathComponent(cacheKey.productName)
            .appendingPathComponent(cacheKey.checksum.stringValue)
    }

}
