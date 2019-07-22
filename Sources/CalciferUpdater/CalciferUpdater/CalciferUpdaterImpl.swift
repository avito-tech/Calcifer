import Foundation
import CalciferConfig
import ZIPFoundation
import ShellCommand
import Toolkit

public final class CalciferUpdaterImpl: CalciferUpdater {
    
    private let updateChecker: UpdateChecker
    private let fileDownloader: FileDownloader
    private let fileManager: FileManager
    private let calciferBinaryPath: String
    private let shellExecutor: ShellCommandExecutor
    
    public init(
        updateChecker: UpdateChecker,
        fileDownloader: FileDownloader,
        fileManager: FileManager,
        calciferBinaryPath: String,
        shellExecutor: ShellCommandExecutor)
    {
        self.updateChecker = updateChecker
        self.fileDownloader = fileDownloader
        self.fileManager = fileManager
        self.calciferBinaryPath = calciferBinaryPath
        self.shellExecutor = shellExecutor
    }
    
    public func updateCalcifer(
        config: CalciferUpdateConfig,
        completion: @escaping (Result<Void, Error>) -> ())
    {
        updateChecker.shouldUpdateCalcifer(
            versionFileURL: config.versionFileURL
        ) { [weak self] result in
            switch result {
            case let .success(shouldUpdate):
                if shouldUpdate == true {
                    self?.downloadZipBinary(
                        from: config.zipBinaryFileURL,
                        completion: completion
                    )
                } else {
                    completion(.success(()))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    private func downloadZipBinary(
        from url: URL,
        completion: @escaping (Result<Void, Error>) -> ())
    {
        fileDownloader.downloadFile(url: url) { [weak self] result in
            switch result {
            case let .success(url):
                self?.process(
                    downloadedZipURL: url,
                    completion: completion
                )
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    private func process(
        downloadedZipURL: URL,
        completion: @escaping (Result<Void, Error>) -> ())
    {
        let unzipURL = fileManager.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        catchError { try fileManager.createDirectory(at: unzipURL, withIntermediateDirectories: true) }
        catchError { try fileManager.unzipItem(at: downloadedZipURL, to: unzipURL) }
        let fileName = calciferBinaryPath.lastPathComponent()
        let unzipBinaryURL = unzipURL.appendingPathComponent(fileName)
        installBinary(binaryPath: unzipBinaryURL.path)
        let resultBinaryURL = URL(fileURLWithPath: calciferBinaryPath)
        if fileManager.fileExists(atPath: resultBinaryURL.path)
            && equalFiles(unzipBinaryURL, resultBinaryURL)
        {
            try? fileManager.removeItem(at: downloadedZipURL)
            try? fileManager.removeItem(at: unzipBinaryURL)
            completion(.success(()))
        } else {
            completion(.failure(CalciferUpdaterError.failedToInstallBinary(url: unzipBinaryURL)))
        }
        
    }
    
    private func equalFiles(_ firstFileURL: URL, _ secondFileURL: URL) -> Bool {
        let firstFileChecksum = catchError { try Data(contentsOf: firstFileURL).md5() }
        let secondFileChecksum = catchError { try Data(contentsOf: secondFileURL).md5() }
        return firstFileChecksum == secondFileChecksum
    }
    
    private func installBinary(binaryPath: String) {
        let command = BaseShellCommand(
            launchPath: binaryPath,
            arguments: [
                "installCalciferBinary"
            ],
            environment: [:]
        )
        let result = shellExecutor.execute(command: command)
        if result.terminationStatus != 0 {
            catchError {
                throw CalciferUpdaterError.failedToExecuteInstall(
                    error: result.error
                )
            }
        }
    }
    
}
