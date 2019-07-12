import Foundation
import XCTest
import Toolkit
import Mock
import CalciferConfig
import ZIPFoundation
import ShellCommand
@testable import CalciferUpdater

public final class CalciferUpdaterImplTests: BaseTestCase {
    
    private lazy var calciferBinaryName = CalciferPathProviderImpl(
        fileManager: fileManager
    ).calciferBinaryName()
    private lazy var binaryDirectory = createTmpDirectory()
    private lazy var destinationDirectory = createTmpDirectory()
    
    func test_updateCalcifer() {
        // Given
        let versionFileURL = url("http://some.com/version.json")
        let zipBinaryFileURL = url("http://some.com/Calcifer.zip")
        let config = CalciferUpdateConfig(
            versionFileURL: versionFileURL,
            zipBinaryFileURL: zipBinaryFileURL
        )
        
        let binaryContent = UUID().uuidString.data(using: .utf8) ?? Data()
        let binaryFileURL = createBinary(content: binaryContent)
        let zipFileURL = createZip(binaryFileURL: binaryFileURL)

        let destinationURL = destinationDirectory
            .appendingPathComponent(calciferBinaryName)
        
        let shellCommandExecutor = ShellCommandExecutorStub()
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
        let result = updateResult.unwrapOrFail()
        switch result {
        case let .failure(error):
            XCTFail("Failed to update with error \(error)")
        case .success:
            break
        }
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
    
    private func createZip(binaryFileURL: URL) -> URL {
        let zipFileURL = binaryDirectory
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
