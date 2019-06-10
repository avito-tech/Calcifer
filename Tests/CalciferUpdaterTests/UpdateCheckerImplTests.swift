import Foundation
import XCTest
import Toolkit
import Mock
import CalciferConfig
@testable import CalciferUpdater

public final class UpdateCheckerImplTests: XCTestCase {
    
    let fileManager = FileManager.default
    let calciferBinaryName = CalciferPathProviderImpl(
        fileManager: FileManager.default
    ).calciferBinaryName()
    let temporaryDirectory = FileManager.default.createTemporaryDirectory()
    
    func test_shouldUpdateCalcifer_not_should() {
        // Given
        guard let versionDownloadURL = URL(string: "http://some.com/version.json")
            else {
                XCTFail("Can't create url from string")
                return
        }
        
        guard let binaryContent = UUID().uuidString.data(using: .utf8) else {
            XCTFail("Can't create data from string")
            return
        }
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
        guard let versionDownloadURL = URL(string: "http://some.com/version.json")
            else {
                XCTFail("Can't create url from string")
                return
        }
        
        guard let binaryContent = UUID().uuidString.data(using: .utf8) else {
            XCTFail("Can't create data from string")
            return
        }
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
        guard let versionDownloadURL = URL(string: "http://some.com/version.json")
            else {
                XCTFail("Can't create url from string")
                return
        }
        
        let binaryFileURL = temporaryDirectory
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
        let binaryFileURL = temporaryDirectory
            .appendingPathComponent(calciferBinaryName)
        fileManager.createFile(
            atPath: binaryFileURL.path,
            contents: content
        )
        return binaryFileURL
    }
    
    private func createVersionFile(checksumData: Data) -> URL {
        let versionURL = temporaryDirectory.appendingPathComponent("version.json")
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
        guard let result = result else {
            XCTFail("Failed to obtain update result")
            return
        }
        switch result {
        case let .failure(error):
            XCTFail("Failed to update with error \(error)")
        case let .success(should):
            XCTAssertEqual(should, expectedSuccess)
        }
    }
    
}
