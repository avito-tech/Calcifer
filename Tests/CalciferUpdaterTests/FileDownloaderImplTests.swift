import Foundation
import XCTest
import Mock
@testable import CalciferUpdater

public final class FileDownloaderImplTests: XCTestCase {
    
    func test_uploadNewVersion() {
        // Given
        let sessionStub = StubURLSession()
        let downloadURL = url("http://some.com/some")
        let expectedDownloadedURL = URL(fileURLWithPath: "/path/file.zip")
        stubSession(sessionStub, downloadURL: downloadURL) {
            expectedDownloadedURL
        }
        let fileDownloader = FileDownloaderImpl(session: sessionStub)
        
        var downloadResult: Result<URL, Error>?
        // When
        fileDownloader.downloadFile(url: downloadURL) { result in
            downloadResult = result
        }
        
        // Then
        guard let result = downloadResult else {
            XCTFail("Failed to obtain update result")
            return
        }
        switch result {
        case let .failure(error):
            XCTFail("Failed to download file with error \(error)")
        case let .success(downloadedFileURl):
            XCTAssertEqual(downloadedFileURl, expectedDownloadedURL)
        }
    }
    
    private func stubSession(
        _ stub: StubURLSession,
        downloadURL: URL,
        onRequest: @escaping () -> (URL))
    {
        
        stub.downloadStub = { request in
            guard let requestURL = request.url else {
                XCTFail("Failed to stub session")
                return (nil, nil, nil)
            }
            var url: URL?
            if requestURL == downloadURL {
                url = onRequest()
            } else {
                XCTFail("Failed to stub session")
            }
            return (url, nil, nil)
        }
    }
    
}
