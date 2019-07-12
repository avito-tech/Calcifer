import Foundation
import XCTest
import Toolkit
import Mock
import CalciferConfig
@testable import CalciferUpdater

public final class UpdateCheckerImplTests: BaseTestCase {
    
    private lazy var calciferBinaryName = CalciferPathProviderImpl(
        fileManager: fileManager
    ).calciferBinaryName()
    private lazy var binaryDirectory = createTmpDirectory()
    
    func test_shouldUpdateCalcifer_not_should() {
        // Given
        let versionDownloadURL = url("http://some.com/version.json")
        let binaryContent = uuid.data(using: .utf8).unwrapOrFail()
        let binaryFileURL = createBinary(content: binaryContent)
        let downloadedVersionURL = createVersionFile(checksumData: binaryContent)
        let updateChecker = createUpdateChecker(
            downloadFileURL: versionDownloadURL,
            downloadedVersionURL: downloadedVersionURL,
            binaryFileURL: binaryFileURL
        )
        
        var checkUpdateResult: Result<Bool, Error>?
        // When
        updateChecker.shouldUpdateCalcifer(versionFileURL: versionDownloadURL) { result in
            checkUpdateResult = result
        }
        
        // Then
        check(checkUpdateResult, expectedSuccess: false)
    }
    
    func test_shouldUpdateCalcifer_should() {
        // Given
        let versionDownloadURL = url("http://some.com/version.json")
        let binaryContent = uuid.data(using: .utf8).unwrapOrFail()
        let binaryFileURL = createBinary(content: binaryContent)
        let downloadedVersionURL = createVersionFile(checksumData: Data())
        let updateChecker = createUpdateChecker(
            downloadFileURL: versionDownloadURL,
            downloadedVersionURL: downloadedVersionURL,
            binaryFileURL: binaryFileURL
        )
        
        var checkUpdateResult: Result<Bool, Error>?
        // When
        updateChecker.shouldUpdateCalcifer(versionFileURL: versionDownloadURL) { result in
            checkUpdateResult = result
        }
        
        // Then
        check(checkUpdateResult, expectedSuccess: true)
    }
    
    func test_shouldUpdateCalcifer_binary_not_exist() {
        // Given
        let versionDownloadURL = url("http://some.com/version.json")
        
        let binaryFileURL = binaryDirectory
            .appendingPathComponent(calciferBinaryName)
        let downloadedVersionURL = createVersionFile(checksumData: Data())
        let updateChecker = createUpdateChecker(
            downloadFileURL: versionDownloadURL,
            downloadedVersionURL: downloadedVersionURL,
            binaryFileURL: binaryFileURL
        )
        
        var checkUpdateResult: Result<Bool, Error>?
        // When
        updateChecker.shouldUpdateCalcifer(versionFileURL: versionDownloadURL) { result in
            checkUpdateResult = result
        }
        
        // Then
        check(checkUpdateResult, expectedSuccess: true)
    }
    
    private func createBinary(content: Data) -> URL {
        let binaryFileURL = binaryDirectory
            .appendingPathComponent(calciferBinaryName)
        fileManager.createFile(
            atPath: binaryFileURL.path,
            contents: content
        )
        return binaryFileURL
    }
    
    private func createVersionFile(checksumData: Data) -> URL {
        let versionURL = binaryDirectory.appendingPathComponent("version.json")
        try? CalciferVersion(checksum: checksumData.md5())
            .save(to: versionURL.path)
        return versionURL
    }
    
    private func createUpdateChecker(
        downloadFileURL: URL,
        downloadedVersionURL: URL,
        binaryFileURL: URL)
        -> UpdateChecker
    {
        let fileDownloader = FileDownloaderStub { url -> (Result<URL, Error>) in
            if url == downloadFileURL {
                return .success(downloadedVersionURL)
            }
            return .failure(CalciferUpdaterError.failedToDownloadFile(url: url))
        }
        return UpdateCheckerImpl(
            fileDownloader: fileDownloader,
            fileManager: fileManager,
            calciferBinaryPath: binaryFileURL.path
        )
    }
    
    func check(_ result: Result<Bool, Error>?, expectedSuccess: Bool) {
        let result = result.unwrapOrFail()
        switch result {
        case let .failure(error):
            XCTFail("Failed to update with error \(error)")
        case let .success(should):
            XCTAssertEqual(should, expectedSuccess)
        }
    }
    
}
