import Foundation
import CalciferConfig
import ZIPFoundation
import ShellCommand
import Toolkit

public final class CalciferUpdaterImpl: CalciferUpdater {
    
    private let session: URLSession
    private let fileManager: FileManager
    private let calciferBinaryPath: String
    private let shellExecutor: ShellCommandExecutor
    
    public init(
        session: URLSession,
        fileManager: FileManager,
        calciferBinaryPath: String,
        shellExecutor: ShellCommandExecutor)
    {
        self.session = session
        self.fileManager = fileManager
        self.calciferBinaryPath = calciferBinaryPath
        self.shellExecutor = shellExecutor
    }
    
    public func updateCalcifer(
        config: CalciferUpdateConfig,
        completion: @escaping (Result<Void, Error>) -> ())
    {
        let currentChecksum = catchError { try obtainCurrentChecksum() }
        downloadFile(url: config.versionFileURL) { result in
            self.shouldDownloadBinary(
                versionDownloadResult: result,
                config: config,
                currentChecksum: currentChecksum,
                completion: completion
            )
        }
    }
    
    private func obtainCurrentChecksum() throws -> String? {
        if fileManager.fileExists(atPath: calciferBinaryPath) {
            return try Data(
                contentsOf: URL(fileURLWithPath: calciferBinaryPath)
            ).md5()
        }
        return nil
    }
    
    private func shouldDownloadBinary(
        versionDownloadResult: Result<URL, Error>,
        config: CalciferUpdateConfig,
        currentChecksum: String?,
        completion: @escaping (Result<Void, Error>) -> ())
    {
        switch versionDownloadResult {
        case let .success(url):
            guard let version = try? CalciferVersion.decode(from: url.path) else {
                let result: Result<Void, Error> = .failure(
                    CalciferUpdaterError.failedToParseVersionFile(url: url)
                )
                completion(result)
                return
            }
            if version.checksum == currentChecksum {
                completion(.success(()))
                return
            }
            downloadZipBinary(
                from: config.zipBinaryFileURL,
                completion: completion
            )
        case let .failure(error):
            let result: Result<Void, Error> = .failure(error)
            completion(result)
        }
    }
    
    private func downloadZipBinary(
        from url: URL,
        completion: @escaping (Result<Void, Error>) -> ())
    {
        self.downloadFile(url: url) { result in
            switch result {
            case let .success(url):
                self.updateCalcifer(
                    downloadedZipURL: url,
                    completion: completion
                )
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    private func updateCalcifer(
        downloadedZipURL: URL,
        completion: @escaping (Result<Void, Error>) -> ())
    {
        let unzipURL = fileManager.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        catchError { try fileManager.createDirectory(at: unzipURL, withIntermediateDirectories: true) }
        catchError { try fileManager.unzipItem(at: downloadedZipURL, to: unzipURL) }
        let unzipBinaryURL = unzipURL.appendingPathComponent(fileManager.calciferBinaryName())
        installBinary(binaryPath: unzipBinaryURL.path)
        let resultBinaryURL = URL(fileURLWithPath: calciferBinaryPath)
        if fileManager.fileExists(atPath: resultBinaryURL.path)
            && equalFiles(unzipBinaryURL, resultBinaryURL)
        {
            catchError { try fileManager.removeItem(at: downloadedZipURL) }
            catchError { try fileManager.removeItem(at: unzipBinaryURL) }
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
                "installCalciferBinary",
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
    
    private func downloadFile(url: URL, completion: @escaping (Result<URL, Error>) -> ()) {
        session.downloadTask(with: url) { (downloadedURL, _, error) in
            guard let downloadedURL = downloadedURL, error == nil else {
                let downloadError = error ?? CalciferUpdaterError.failedToDownloadFile(url: url)
                completion(.failure(downloadError))
                return
            }
            completion(.success(downloadedURL))
        }.resume()
    }
}
