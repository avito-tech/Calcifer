import Foundation
import XCTest
import Checksum
import ShellCommand
@testable import BuildProductCacheStorage

public final class GradleRemoteBuildProductCacheStorageTests: XCTestCase {
    
    private let fileManager = FileManager.default
    private let client = GradleBuildCacheClientMock()
    private let unzip = Unzip(shellExecutor: ShellCommandExecutorImpl())
    
    func test_add() {
        // Given
        let storage = GradleRemoteBuildProductCacheStorage(
            gradleBuildCacheClient: client,
            unzip: unzip,
            fileManager: fileManager
        )
        let checksum = BaseChecksum(UUID().uuidString)
        let frameworkName = UUID().uuidString
            .appendingPathComponent(".framework")
        let key = BuildProductCacheKey(
            productName: frameworkName,
            productType: .framework,
            checksum: checksum
        )
        let fileURL = URL(
            fileURLWithPath: NSTemporaryDirectory()
        ).appendingPathComponent(UUID().uuidString)
        fileManager.createFile(atPath: fileURL.path, contents: nil)
        
        // When
        storage.add(cacheKey: key, at: fileURL.path) { [weak self] in
            // Then
            guard let strongSelf = self else {
                XCTFail("Failed unwrap self")
                return
            }
            guard let uploadFileURL = strongSelf.client.uploadFileURL else {
                XCTFail("UploadFileURL is nil")
                return
            }
            XCTAssertFalse(strongSelf.fileManager.fileExists(atPath: uploadFileURL.path))
        }
    }
    
    func test_cached() {
        // Given
        let storage = GradleRemoteBuildProductCacheStorage(
            gradleBuildCacheClient: client,
            unzip: unzip,
            fileManager: fileManager
        )
        let checksum = BaseChecksum(UUID().uuidString)
        let productName = UUID().uuidString + ".framework"
        let key = BuildProductCacheKey(
            productName: productName,
            productType: .framework,
            checksum: checksum
        )
        let zipFileURL = createZipFile(key: key)
        client.downloadResultURL = zipFileURL
        
        // When
        storage.cached(for: key) { result in
            // Then
            switch result {
            case let .result(value):
                XCTAssertEqual(value.key.productName, key.productName)
                XCTAssertEqual(value.key.checksum, key.checksum)
                XCTAssertTrue(FileManager.default.fileExists(atPath: value.path))
                do {
                    try FileManager.default.removeItem(atPath: value.path)
                } catch {
                    XCTFail("Failed to remote")
                }
            case .notExist:
                XCTFail("Failed obtain cache value")
            }
        }
    }
    
    private func createZipFile(key: BuildProductCacheKey<BaseChecksum>) -> URL {
        let fileDirecotry = URL(fileURLWithPath: NSTemporaryDirectory())
        do {
            let fileURL = fileDirecotry
                .appendingPathComponent(key.productName)
            fileManager.createFile(atPath: fileURL.path, contents: nil)
            let zipFileURL = URL(fileURLWithPath: NSTemporaryDirectory())
                .appendingPathComponent(UUID().uuidString)
                .appendingPathExtension("zip")
            try fileManager.zipItem(at: fileURL, to: zipFileURL)
            try fileManager.removeItem(at: fileURL)
            return zipFileURL
        } catch {
            XCTFail("Failed create zip")
            fatalError("Failed create zip")
        }
    }
}
