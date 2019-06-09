import Foundation
import XCTest
import Toolkit
import Mock
import CalciferConfig
import ZIPFoundation
import ShellCommand
@testable import CalciferUpdater

public final class CalciferUpdaterImplTests: XCTestCase { 
    
    let fileManager = FileManager.default
    let calciferBinaryName = CalciferPathProviderImpl(
        fileManager: FileManager.default
    ).calciferBinaryName()
    let temporaryDirectory = FileManager.default.createTemporaryDirectory()
    
    func test_updateCalcifer() {
        // Given
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
        
        let binaryContent = UUID().uuidString.data(using: .utf8) ?? Data()
        let binaryFileURL = createBinary(content: binaryContent)
        let zipFileURL = createZip(binaryFileURL: binaryFileURL)

        let destinationURL = fileManager.createTemporaryDirectory()
            .appendingPathComponent(calciferBinaryName)
        
        let shellCommandExecutor = ShellCommandExecutorStub() { command in
            XCTFail(
                "Incorrect command launchPath \(command.launchPath) or arguments \(command.arguments)"
            )
        }
        shellCommandExecutor.stub = { command in
            XCTAssertEqual(command.arguments, ["installCalciferBinary"])
            try? self.fileManager.copyItem(
                at: URL(fileURLWithPath: command.launchPath),
                to: destinationURL
            )
            return ShellCommandResult(terminationStatus: 0)
        }
        
        let updateChecker = UpdateCheckerStub { url -> (Result<Bool, Error>) in
            if url == versionFileURL {
                return .success(true)
            }
            return .failure(CalciferUpdaterError.failedToDownloadFile(url: url))
        }
        let fileDownloader = FileDownloaderStub { url -> (Result<URL, Error>) in
            if url == zipBinaryFileURL {
                return .success(zipFileURL)
            }
            return .failure(CalciferUpdaterError.failedToDownloadFile(url: url))
        }
        let updater = CalciferUpdaterImpl(
            updateChecker: updateChecker,
            fileDownloader: fileDownloader,
            fileManager: fileManager,
            calciferBinaryPath: destinationURL.path,
            shellExecutor: shellCommandExecutor
        )

        var updateResult: Result<Void, Error>?
        // When
        updater.updateCalcifer(config: config) { result in
            updateResult = result
        }
        
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
    
    private func createBinary(content: Data) -> URL {
        let binaryFileURL = temporaryDirectory
            .appendingPathComponent(calciferBinaryName)
        fileManager.createFile(
            atPath: binaryFileURL.path,
            contents: content
        )
        return binaryFileURL
    }
    
    private func createZip(binaryFileURL: URL) -> URL {
        let zipFileURL = temporaryDirectory
            .appendingPathComponent(calciferBinaryName)
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
        return zipFileURL
    }
    
}
