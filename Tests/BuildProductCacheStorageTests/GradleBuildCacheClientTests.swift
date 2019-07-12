import Foundation
import XCTest
import Mock
@testable import BuildProductCacheStorage

public final class GradleBuildCacheClientTests: XCTestCase {
    
    func test_download() {
        // Given
        let host = url("http://stub.com")
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
        let unwrappedResult = downloadResult.unwrapOrFail()
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
        let host = url("http://stub.com")
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
        let unwrappedResult = uploadResult.unwrapOrFail()
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
