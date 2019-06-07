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
        completion: @escaping (Result<URL, Error>) -> ()) throws
    {
        let currentChecksum = try obtainCurrentChecksum()
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
        completion: @escaping (Result<URL, Error>) -> ())
    {
        switch versionDownloadResult {
        case let .success(url):
            guard let version = try? CalciferVersion.decode(from: url.path) else {
                let result: Result<URL, Error> = .failure(
                    CalciferUpdaterError.failedToParseVersionFile(url: url)
                )
                completion(result)
                return
            }
            if version.checksum == currentChecksum {
                completion(versionDownloadResult)
                return
            }
            downloadBinary(from: config.zipBinaryFileURL, completion: completion)
        case .failure:
            completion(versionDownloadResult)
        }
    }
    
    private func downloadBinary(from url: URL, completion: @escaping (Result<URL, Error>) -> ()) {
        self.downloadFile(url: url) { result in
            switch result {
            case let .success(url):
                self.updateCalcifer(
                    zipURL: url,
                    completion: completion
                )
            case .failure:
                completion(result)
            }
        }
    }
    
    private func updateCalcifer(zipURL: URL, completion: @escaping (Result<URL, Error>) -> ()) {
        let unzipURL = fileManager.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        catchError { try fileManager.createDirectory(at: unzipURL, withIntermediateDirectories: true) }
        catchError { try fileManager.unzipItem(at: zipURL, to: unzipURL) }
        let unzipBinaryURL = unzipURL.appendingPathComponent(fileManager.calciferBinaryName())
        installBinary(binaryPath: unzipBinaryURL.path)
        let resultBinaryURL = URL(fileURLWithPath: calciferBinaryPath)
        if fileManager.fileExists(atPath: resultBinaryURL.path)
            && equalFiles(unzipBinaryURL, resultBinaryURL)
        {
            catchError { try fileManager.removeItem(at: zipURL) }
            catchError { try fileManager.removeItem(at: unzipBinaryURL) }
            completion(.success(resultBinaryURL))
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
