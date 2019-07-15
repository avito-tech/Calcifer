import Foundation
import XCTest
import Toolkit
import Mock
import CalciferConfig
@testable import CalciferVersionShipper

public final class CalciferVersionShipperImplTests: BaseTestCase {
    
    private lazy var binaryData: Data = {
        UUID().uuidString.data(using: .utf8).unwrapOrFail()
    }()
    private lazy var binaryPath = createTmpFile(data: binaryData)
    
    func test_uploadNewVersion() {
        // Given
        let expectedChecksum = binaryData.md5()
        let versionFileURL = url("http://some.com/version.json")
        let zipBinaryFileURL = url("http://some.com/Calcifer.zip")
        let config = CalciferShipConfig(
            versionFileURL: versionFileURL,
            zipBinaryFileURL: zipBinaryFileURL,
            basicAccessAuthentication: BasicAccessAuthentication(
                login: "USER",
                password: "PASSWORD"
            )
        )
        
        let sessionStub = StubURLSession()
        let shipper = CalciferVersionShipperImpl(
            session: sessionStub,
            fileManager: fileManager
        )
        
        stubSession(
            sessionStub,
            config: config,
            onVersionRequest: { url in
                let version = (try? CalciferVersion.decode(from: url.path)).unwrapOrFail()
                XCTAssertEqual(version.checksum, expectedChecksum)
            }, onZipRequest: { [fileManager] url in
                XCTAssertTrue(fileManager.fileExists(atPath: url.path))
            }
        )
        
        var shipResult: Result<Void, Error>?
        // When
        shipper.shipCalcifer(at: binaryPath.path, config: config) { result in
            shipResult = result
        }
        
        // Then
        let result = shipResult.unwrapOrFail()
        switch result {
        case let .failure(error):
            XCTFail("Failed to upload with error \(error)")
        case .success:
            break
        }
    }
    
    private func stubSession(
        _ stub: StubURLSession,
        config: CalciferShipConfig,
        onVersionRequest: @escaping (URL) -> (),
        onZipRequest: @escaping (URL) -> ())
    {
        
        stub.uploadStub = { request, url in
            guard let requestURL = request.url else {
                XCTFail("Failed to stub session")
                return (nil, nil, nil)
            }
            XCTAssertEqual(request.httpMethod, "PUT")
            if requestURL == config.versionFileURL {
                onVersionRequest(url)
            } else if requestURL == config.zipBinaryFileURL {
                onZipRequest(url)
            } else {
                XCTFail("Failed to stub session")
            }
            if let base64Credentials = config.basicAccessAuthentication?.stringValue
                .data(using: .utf8)?
                .base64EncodedString()
            {
                XCTAssertEqual(
                    request.value(forHTTPHeaderField: "Authorization"),
                    "Basic \(base64Credentials)"
                )
            }
            return (nil, nil, nil)
        }
    }
    
}
