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
            let entry = CacheEntry(
                name: "Some",
                checksum: BaseChecksum(UUID().uuidString)
            )
            let frameworkContainingFolderPath = try createArtifactFile(
                fileManager: fileManager,
                entry: entry
            )
            let expectedPath = obtainExpectedPath(for: entry)
            
            // When
            try storage.add(entry: entry, at: frameworkContainingFolderPath)
            guard let optionalValue = try? storage.cache(for: entry),
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
        entry: CacheEntry<BaseChecksum>)
        throws -> String
    {
        let currentPath = cacheDirectoryPath.appendingPathComponent("Debug-iphoneos")
        let frameworkContainingFolderPath = currentPath.appendingPathComponent(entry.name)
        let frameworkPath = frameworkContainingFolderPath.appendingPathComponent("\(entry.name).framework")
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
    
    private func obtainExpectedPath(for entry: CacheEntry<BaseChecksum>) -> String {
         return cacheDirectoryPath
            .appendingPathComponent(entry.name)
            .appendingPathComponent(entry.checksum.description)
    }

}
