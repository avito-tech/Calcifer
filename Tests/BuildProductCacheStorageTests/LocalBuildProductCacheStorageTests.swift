import Foundation
import XCTest
import Mock
import Checksum
@testable import BuildProductCacheStorage

public final class LocalBuildProductCacheStorageTests: BaseTestCase {
    
    private lazy var cacheDirectoryPath = createTmpDirectory().path
    private lazy var storage = LocalBuildProductCacheStorage(
        fileManager: fileManager,
        cacheDirectoryPath: cacheDirectoryPath,
        maxAgeInDaysForLocalArtifact: 1
    )
    
    func test_addCache() {
        // Given
        let cacheKey = createCacheKey(name: "Some")
        let frameworkContainingFolderPath = createArtifactFile(
            cacheKey: cacheKey
        )
        let expectedPath = obtainExpectedPath(for: cacheKey)
        
        // When
        addToStorage(cacheKey: cacheKey, at: frameworkContainingFolderPath)
        
        // Then
        let result = obtainFromStorage(cacheKey: cacheKey)
        switch result {
        case let .result(value):
            XCTAssertTrue(fileManager.directoryExist(at: expectedPath))
            XCTAssertEqual(value.path, expectedPath)
        case .notExist:
            XCTFail("Failed add cache")
        }
    }
    
    func test_clear() {
        // Given
        let firstCacheKey = createCacheKey(name: "First")
        let firstFrameworkContainingFolderPath = createArtifactFile(
            cacheKey: firstCacheKey
        )
        addToStorage(cacheKey: firstCacheKey, at: firstFrameworkContainingFolderPath)
        
        let secondCacheKey = createCacheKey(name: "Second")
        let secondFrameworkContainingFolderPath = createArtifactFile(
            cacheKey: firstCacheKey
        )
        let secondExpectedPath = obtainExpectedPath(for: secondCacheKey)
        addToStorage(cacheKey: secondCacheKey, at: secondFrameworkContainingFolderPath)
        changeAccessDate(cacheKey: firstCacheKey)
        
        // When
        DispatchGroup.wait { dispatchGroup in
            storage.clean {
                dispatchGroup.leave()
            }
        }
        
        // Then
        let firstResult = obtainFromStorage(cacheKey: firstCacheKey)
        let secondResult = obtainFromStorage(cacheKey: secondCacheKey)
        switch firstResult {
        case .result:
            XCTFail("Failed add cache")
        case .notExist:
            break
        }

        switch secondResult {
        case let .result(value):
            XCTAssertTrue(fileManager.directoryExist(at: secondExpectedPath))
            XCTAssertEqual(value.path, secondExpectedPath)
        case .notExist:
            XCTFail("Failed add cache")
        }
    }
    
    private func changeAccessDate(cacheKey: BuildProductCacheKey<BaseChecksum>) {
        let result = obtainFromStorage(cacheKey: cacheKey)
        switch result {
        case let .result(value):
            changeAccessDate(path: value.path.deletingLastPathComponent())
        case .notExist:
            break
        }
    }
    
    private func changeAccessDate(path: String) {
        let outdateTimeInterval = TimeInterval(-Int(2) * 24 * 60 * 60)
        let outdate = Date().addingTimeInterval(outdateTimeInterval)
        var url = URL(fileURLWithPath: path)
        let resourceValues = try? url.resourceValues(forKeys: Set([URLResourceKey.contentAccessDateKey]))
        if var resourceValues = resourceValues {
            resourceValues.contentAccessDate = outdate
            try? url.setResourceValues(resourceValues)
        }
    }
    
    private func obtainFromStorage(
        cacheKey: BuildProductCacheKey<BaseChecksum>)
        -> BuildProductCacheResult<BaseChecksum>
    {
        var cached: BuildProductCacheResult<BaseChecksum>?
        DispatchGroup.wait { dispatchGroup in
            storage.cached(for: cacheKey) { result in
                cached = result
                dispatchGroup.leave()
            }
        }
        guard let cacheResult = cached else {
            fatalError()
        }
        return cacheResult
    }
    
    private func addToStorage(cacheKey: BuildProductCacheKey<BaseChecksum>, at path: String) {
        DispatchGroup.wait { dispatchGroup in
            storage.add(
                cacheKey: cacheKey,
                at: path)
            {
                dispatchGroup.leave()
            }
        }
    }
    
    private func createCacheKey(name: String) -> BuildProductCacheKey<BaseChecksum> {
        return BuildProductCacheKey(
            productName: "\(name).framework",
            productType: .product(.framework),
            checksum: BaseChecksum(UUID().uuidString)
        )
    }
    
    private func createArtifactFile(
        cacheKey: BuildProductCacheKey<BaseChecksum>)
        -> String
    {
        let currentPath = cacheDirectoryPath.appendingPathComponent("Debug-iphoneos")
        let frameworkContainingFolderPath = currentPath.appendingPathComponent(cacheKey.productName)
        let frameworkPath = frameworkContainingFolderPath
            .appendingPathComponent(cacheKey.productName.deletingPathExtension())
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
            .appendingPathComponent(cacheKey.productType.shortName)
            .appendingPathComponent(cacheKey.productName.deletingPathExtension())
            .appendingPathComponent(cacheKey.checksum.stringValue)
            .appendingPathComponent(cacheKey.productName)
    }

}
