import Foundation
import XCTest
import Checksum
@testable import CacheStorage

public final class LocalCacheStorageTests: XCTestCase {
    
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
            let storage = LocalCacheStorage<BaseChecksum>(
                fileManager: fileManager,
                cacheDirectoryPath: cacheDirectoryPath
            )
            let cacheKey = CacheKey(
                name: "Some",
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
            XCTAssertFalse(fileManager.directoryExist(at: expectedPath))
            XCTAssertEqual(value.path, expectedPath)
        }(), "Caught exception")
    }
    
    private func createArtifactFile(
        fileManager: FileManager,
        cacheKey: CacheKey<BaseChecksum>)
        throws -> String
    {
        let currentPath = cacheDirectoryPath.appendingPathComponent("Debug-iphoneos")
        let frameworkContainingFolderPath = currentPath.appendingPathComponent(cacheKey.name)
        let frameworkPath = frameworkContainingFolderPath.appendingPathComponent("\(cacheKey.name).framework")
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
    
    private func obtainExpectedPath(for cacheKey: CacheKey<BaseChecksum>) -> String {
         return cacheDirectoryPath
            .appendingPathComponent(cacheKey.name)
            .appendingPathComponent(cacheKey.checksum.description)
    }

}
