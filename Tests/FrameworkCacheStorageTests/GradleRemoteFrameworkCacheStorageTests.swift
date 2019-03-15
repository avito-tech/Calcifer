import Foundation
import XCTest
import Checksum
@testable import FrameworkCacheStorage

public final class GradleRemoteFrameworkCacheStorageTests: XCTestCase {
    
    private let fileManager = FileManager.default
    private let client = GradleBuildCacheClientMock()
    
    func test_add() {
        // Given
        let storage = GradleRemoteFrameworkCacheStorage<BaseChecksum>(
            gradleBuildCacheClient: client,
            fileManager: fileManager
        )
        let checksum = BaseChecksum(UUID().uuidString)
        let frameworkName = UUID().uuidString
        let key = FrameworkCacheKey(
            frameworkName: frameworkName,
            checksum: checksum
        )
        let fileURL = URL(
            fileURLWithPath: NSTemporaryDirectory()
        ).appendingPathComponent(UUID().uuidString)
        fileManager.createFile(atPath: fileURL.path, contents: nil)
        
        // When
        XCTAssertNoThrow(try storage.add(cacheKey: key, at: fileURL.path))
        
        // Then
        XCTAssertEqual(checksum.stringValue, client.key)
        guard let uploadFileURL = client.uploadFileURL else {
            XCTFail("UploadFileURL is nil")
            return
        }
        XCTAssertFalse(fileManager.fileExists(atPath: uploadFileURL.path))
    }
    
    func test_cached() {
        XCTAssertNoThrow(try {
            // Given
            let storage = GradleRemoteFrameworkCacheStorage<BaseChecksum>(
                gradleBuildCacheClient: client,
                fileManager: fileManager
            )
            let checksum = BaseChecksum(UUID().uuidString)
            let frameworkName = UUID().uuidString
            let key = FrameworkCacheKey(
                frameworkName: frameworkName,
                checksum: checksum
            )
            let zipFileURL = try createZipFile(key: checksum.stringValue)
            client.downloadResultURL = zipFileURL
            
            // When
            let cached = try storage.cached(for: key)
            
            // Then
            XCTAssertEqual(checksum.stringValue, client.key)
            XCTAssertEqual(cached?.key, key)
            guard let resultPath = cached?.path else {
                XCTFail("Result path is nil")
                return
            }
            XCTAssertTrue(fileManager.fileExists(atPath: resultPath))
            try fileManager.removeItem(atPath: resultPath)
        }(), "Caught exception")
    }
    
    private func createZipFile(key: String) throws -> URL {
        let fileDirecotry = URL(
            fileURLWithPath: NSTemporaryDirectory()
            ).appendingPathComponent(key)
        try fileManager.createDirectory(
            at: fileDirecotry,
            withIntermediateDirectories: true
        )
        let fileURL = fileDirecotry.appendingPathComponent(UUID().uuidString)
        fileManager.createFile(atPath: fileURL.path, contents: nil)
        let zipFileURL = URL(
            fileURLWithPath: NSTemporaryDirectory()
            ).appendingPathComponent(UUID().uuidString)
            .appendingPathExtension("zip")
        try fileManager.zipItem(at: fileDirecotry, to: zipFileURL)
        try fileManager.removeItem(at: fileDirecotry)
        return zipFileURL
    }
}
