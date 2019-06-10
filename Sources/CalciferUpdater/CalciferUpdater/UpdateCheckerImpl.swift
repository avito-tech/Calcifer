import Foundation
import CalciferConfig
import Toolkit

public final class UpdateCheckerImpl: UpdateChecker {
    
    private let fileDownloader: FileDownloader
    private let fileManager: FileManager
    private let calciferBinaryPath: String
    
    public init(
        fileDownloader: FileDownloader,
        fileManager: FileManager,
        calciferBinaryPath: String)
    {
        self.fileDownloader = fileDownloader
        self.fileManager = fileManager
        self.calciferBinaryPath = calciferBinaryPath
    }
    
    public func shouldUpdateCalcifer(
        versionFileURL: URL,
        completion: @escaping (Result<Bool, Error>) -> ())
    {
        fileDownloader.downloadFile(url: versionFileURL) { [weak self] result in
            self?.decideShouldUpdate(
                versionDownloadResult: result,
                completion: completion
            )
        }
    }
    
    private func decideShouldUpdate(
        versionDownloadResult: Result<URL, Error>,
        completion: @escaping (Result<Bool, Error>) -> ())
    {
        switch versionDownloadResult {
        case let .success(url):
            guard let version = try? CalciferVersion.decode(from: url.path) else {
                completion(
                    .failure(
                        CalciferUpdaterError.failedToParseVersionFile(url: url)
                    )
                )
                return
            }
            let currentChecksum = catchError { try obtainCurrentChecksum() }
            if version.checksum == currentChecksum {
                completion(.success(false))
                return
            }
            completion(.success(true))
        case let .failure(error):
            completion(.failure(error))
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
    
}
