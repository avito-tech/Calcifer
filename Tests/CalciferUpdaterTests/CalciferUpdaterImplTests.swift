import Foundation
import XCTest
import Toolkit
import Mock
import CalciferConfig
import ZIPFoundation
import ShellCommand
@testable import CalciferUpdater

public final class CalciferUpdaterImplTests: XCTestCase {
    
    func test_uploadNewVersion() {
        // Given
        let fileManager = FileManager.default
        guard let versionFileURL = URL(string: "http://some.com/version.json"),
            let zipBinaryFileURL = URL(string: "http://some.com/Calcifer.zip")
            else {
                XCTFail("Can't create url from string")
                return
        }
        let config = CalciferUpdateConfig(
            versionFileURL: versionFileURL,
            zipBinaryFileURL: zipBinaryFileURL
        )
        let binaryPath = UUID().uuidString
        
        let temporaryDirectory = fileManager.temporaryDirectory
            .appendingPathComponent(UUID().uuidString)
        XCTAssertNoThrow(
            try fileManager.createDirectory(
                at: temporaryDirectory,
                withIntermediateDirectories: true
            )
        )
        let binaryFileURL = temporaryDirectory
            .appendingPathComponent(fileManager.calciferBinaryName())
        
        guard let binaryContent = UUID().uuidString.data(using: .utf8) else {
            XCTFail("Can't create data from string")
            return
        }
        fileManager.createFile(
            atPath: binaryFileURL.path,
            contents: binaryContent
        )
        let zipFileURL = temporaryDirectory
            .appendingPathComponent(fileManager.calciferBinaryName())
            .appendingPathExtension("zip")
        XCTAssertNoThrow(
            try fileManager.zipItem(
                at: binaryFileURL,
                to: zipFileURL
            )
        )
        XCTAssertNoThrow(
            try fileManager.removeItem(at: binaryFileURL)
        )
        
        let versionURL = temporaryDirectory.appendingPathComponent("version.json")
        XCTAssertNoThrow(
            try CalciferVersion(checksum: binaryContent.md5())
                .save(to: versionURL.path)
        )
        
        let sessionStub = StubURLSession()
        stubSession(
            sessionStub,
            config: config,
            onVersionRequest: {
                return versionURL
            }, onZipRequest: {
                return zipFileURL
            }
        )
        
        let destinationDirectory = fileManager.temporaryDirectory
            .appendingPathComponent(UUID().uuidString)
        XCTAssertNoThrow(
            try fileManager.createDirectory(
                at: destinationDirectory,
                withIntermediateDirectories: true
            )
        )
        let destinationURL = destinationDirectory
            .appendingPathComponent(fileManager.calciferBinaryName())
        
        let shellCommandExecutor = ShellCommandExecutorStub() { command in
            XCTFail(
                "Incorrect command launchPath \(command.launchPath) or arguments \(command.arguments)"
            )
        }
        shellCommandExecutor.stub = { command in
            XCTAssertEqual(command.arguments, ["installCalciferBinary"])
            try? fileManager.copyItem(
                at: URL(fileURLWithPath: command.launchPath),
                to: destinationURL
            )
            return ShellCommandResult(terminationStatus: 0)
        }
        

        let updater = CalciferUpdaterImpl(
            session: sessionStub,
            fileManager: fileManager,
            calciferBinaryPath: destinationURL.path,
            shellExecutor: shellCommandExecutor
        )

        var updateResult: Result<URL, Error>?
        // When
        XCTAssertNoThrow(
            try updater.updateCalcifer(config: config) { result in
                updateResult = result
            }
        )
        
        // Then
        guard let result = updateResult else {
            XCTFail("Failed to obtain update result")
            return
        }
        switch result {
        case let .failure(error):
            XCTFail("Failed to update with error \(error)")
        case .success:
            break
        }
    }
    
    private func stubSession(
        _ stub: StubURLSession,
        config: CalciferUpdateConfig,
        onVersionRequest: @escaping () -> (URL),
        onZipRequest: @escaping () -> (URL))
    {
        
        stub.downloadStub = { request in
            guard let requestURL = request.url else {
                XCTFail("Failed to stub session")
                return (nil, nil, nil)
            }
            var url: URL? = nil
            if requestURL == config.versionFileURL {
                url = onVersionRequest()
            } else if requestURL == config.zipBinaryFileURL {
                url = onZipRequest()
            } else {
                XCTFail("Failed to stub session")
            }
            return (url, nil, nil)
        }
    }
    
}
