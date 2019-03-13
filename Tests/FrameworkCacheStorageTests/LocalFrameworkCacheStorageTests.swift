import Foundation
import XCTest
import Checksum
@testable import FrameworkCacheStorage

public final class LocalFrameworkCacheStorageTests: XCTestCase {
    
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
            let storage = LocalFrameworkCacheStorage<BaseChecksum>(
                fileManager: fileManager,
                cacheDirectoryPath: cacheDirectoryPath
            )
            let cacheKey = FrameworkCacheKey(
                frameworkName: "Some",
                checksum: BaseChecksum(UUID().uuidString)
            )
            let frameworkContainingFolderPath = try createArtifactFile(
                fileManager: fileManager,
                cacheKey: cacheKey
            )
            let expectedPath = obtainExpectedPath(for: cacheKey)
            
            // When
            try storage.add(cacheKey: cacheKey, at: frameworkContainingFolderPath)
            guard let optionalValue = try? storage.cache(for: cacheKey),
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
        cacheKey: FrameworkCacheKey<BaseChecksum>)
        throws -> String
    {
        let currentPath = cacheDirectoryPath.appendingPathComponent("Debug-iphoneos")
        let frameworkContainingFolderPath = currentPath.appendingPathComponent(cacheKey.frameworkName)
        let frameworkPath = frameworkContainingFolderPath.appendingPathComponent("\(cacheKey.frameworkName).framework")
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
    
    private func obtainExpectedPath(for cacheKey: FrameworkCacheKey<BaseChecksum>) -> String {
         return cacheDirectoryPath
            .appendingPathComponent(cacheKey.frameworkName)
            .appendingPathComponent(cacheKey.checksum.description)
    }

}
