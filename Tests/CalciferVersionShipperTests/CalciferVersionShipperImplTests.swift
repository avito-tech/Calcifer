import Foundation
import XCTest
import Toolkit
import Mock
import CalciferConfig
@testable import CalciferVersionShipper

public final class CalciferVersionShipperImplTests: XCTestCase {
    
    func test_uploadNewVersion() {
        // Given
        let fileManager = FileManager.default
        let binaryPath = fileManager.temporaryDirectory
            .appendingPathComponent(UUID().uuidString)
        guard let data = UUID().uuidString.data(using: .utf8) else {
            XCTFail("Can't create data from string")
            return
        }
        fileManager.createFile(
            atPath: binaryPath.path,
            contents: data
        )
        let expectedChecksum = data.md5()
        
        guard let versionFileURL = URL(string: "http://some.com/version.json"),
            let zipBinaryFileURL = URL(string: "http://some.com/Calcifer.zip")
            else {
                XCTFail("Can't create url from string")
                return
        }
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
                if let version = try? CalciferVersion.decode(from: url.path) {
                    XCTAssertEqual(version.checksum, expectedChecksum)
                } else {
                    XCTFail("Failed to decode version file")
                }
            }, onZipRequest: { url in
                XCTAssertTrue(fileManager.fileExists(atPath: url.path))
            }
        )
        
        var shipResult: Result<Void, Error>?
        // When
        shipper.shipCalcifer(at: binaryPath.path, config: config) { result in
            shipResult = result
        }
        
        // Then
        guard let result = shipResult else {
            XCTFail("Failed to obtain ship result")
            return
        }
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
