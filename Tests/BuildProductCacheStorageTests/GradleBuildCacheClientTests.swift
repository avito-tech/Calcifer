import Foundation
import XCTest
@testable import BuildProductCacheStorage

public final class GradleBuildCacheClientTests: XCTestCase {
    
    func test_download() {
        // Given
        guard let host = URL(string: "http://stub.com") else {
            XCTFail("Unable to create host url")
            return
        }
        let responseURL = host.appendingPathComponent(UUID().uuidString)
        let key = UUID().uuidString
        let session = StubURLSession()
        var downloadRequest: URLRequest?
        session.downloadStub = { request in
            downloadRequest = request
            let response = HTTPURLResponse(
                url: host,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )
            return (responseURL, response, nil)
        }
        let client = GradleBuildCacheClientImpl(gradleHost: host, session: session)
        var downloadResult: BuildCacheClientResult<URL>?
        let expectedDownloadURL = expectedURL(host: host, key: key)
        
        // When
        client.download(key: key) { result in
            downloadResult = result
        }
        
        // Then
        guard let unwrappedResult = downloadResult else {
            XCTFail("Download result is nil")
            return
        }
        switch unwrappedResult {
        case let .failure(error):
            XCTFail("Failed download cache item \(error.debugDescription)")
        case let .success(url):
            XCTAssertEqual(url, responseURL)
        }
        XCTAssertEqual(downloadRequest?.url, expectedDownloadURL)
        XCTAssertEqual(downloadRequest?.httpMethod, "GET")
    }
    
    func test_upload() {
        // Given
        guard let host = URL(string: "http://stub.com") else {
            XCTFail("Unable to create host url")
            return
        }
        let key = UUID().uuidString
        let session = StubURLSession()
        var uploadRequest: URLRequest?
        session.uploadStub = { request, fileURL in
            uploadRequest = request
            return (nil, nil, nil)
        }
        let client = GradleBuildCacheClientImpl(gradleHost: host, session: session)
        var uploadResult: BuildCacheClientResult<Void>?
        let expectedUploadURL = expectedURL(host: host, key: key)
        
        // When
        client.upload(fileURL: host, key: key) { result in
            uploadResult = result
        }
        
        // Then
        guard let unwrappedResult = uploadResult else {
            XCTFail("Download result is nil")
            return
        }
        switch unwrappedResult {
        case let .failure(error):
            XCTFail("Failed download cache item \(error.debugDescription)")
        case .success:
            XCTAssertEqual(uploadRequest?.url, expectedUploadURL)
            XCTAssertEqual(uploadRequest?.httpMethod, "PUT")
        }
    }
    
    private func expectedURL(host: URL, key: String) -> URL {
        return host.appendingPathComponent("cache")
            .appendingPathComponent(key)
    }

}
