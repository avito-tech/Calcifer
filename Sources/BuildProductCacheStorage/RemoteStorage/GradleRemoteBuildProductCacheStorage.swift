import Foundation
import ZIPFoundation
import Checksum
import Toolkit

public final class GradleRemoteBuildProductCacheStorage: BuildProductCacheStorage {
    
    private let gradleBuildCacheClient: GradleBuildCacheClient
    private let fileManager: FileManager
    private let unzip: Unzip
    private let unzipQueue = DispatchQueue(label: "Queue for unzip", attributes: .concurrent)
    
    public init(
        gradleBuildCacheClient: GradleBuildCacheClient,
        unzip: Unzip,
        fileManager: FileManager)
    {
        self.gradleBuildCacheClient = gradleBuildCacheClient
        self.unzip = unzip
        self.fileManager = fileManager
    }
    
    // MARK: - FrameworkCacheStorage
    public func cached<ChecksumType: Checksum>(
        for cacheKey: BuildProductCacheKey<ChecksumType>,
        completion: @escaping (BuildProductCacheResult<ChecksumType>) -> ())
    {
        let key = gradleKey(for: cacheKey)
        gradleBuildCacheClient.download(key: key) { [weak self] result in
            self?.processDownloadResult(
                result: result,
                cacheKey: cacheKey,
                completion: completion
            )
        }
    }
    
    public func add<ChecksumType: Checksum>(
        cacheKey: BuildProductCacheKey<ChecksumType>,
        at path: String,
        completion: @escaping () -> ())
    {
        let artifactURL = URL(fileURLWithPath: path)
        let key = gradleKey(for: cacheKey)
        let zipFileURL = URL(
            fileURLWithPath: path.deletingLastPathComponent()
        ).appendingPathComponent(key + ".zip")
        catchError { try fileManager.zipItem(at: artifactURL, to: zipFileURL) }
        gradleBuildCacheClient.upload(fileURL: zipFileURL, key: key) { _ in
            catchError { [weak self] in
                try self?.fileManager.removeItem(at: zipFileURL)
            }
            completion()
        }
    }
    
    private func processDownloadResult<ChecksumType: Checksum>(
        result: BuildCacheClientResult<URL>,
        cacheKey: BuildProductCacheKey<ChecksumType>,
        completion: @escaping (BuildProductCacheResult<ChecksumType>) -> ())
    {
        switch result {
        case let .success(url):
            // I move file because URLSession remove it after queue switch
            let newURL = url.deletingLastPathComponent()
                .appendingPathComponent(UUID().uuidString)
            catchError { [weak self] in try self?.fileManager.moveItem(at: url, to: newURL) }
            unzipQueue.async { [weak self] in
                self?.unzipArtifact(
                    url: newURL,
                    cacheKey: cacheKey,
                    completion: completion
                )
            }
        case let .failure(error):
            Logger.verbose("Download cache for \(cacheKey) failure \(error?.localizedDescription ?? "-")")
            completion(.notExist)
        }
    }
    
    private func unzipArtifact<ChecksumType: Checksum>(
        url: URL,
        cacheKey: BuildProductCacheKey<ChecksumType>,
        completion: @escaping (BuildProductCacheResult<ChecksumType>) -> ())
    {
        let unzipURL = url.deletingLastPathComponent()
        var productName = cacheKey.productName.deletingPathExtension()
        productName.append(cacheKey.productType.fileExtension)
        let unzipResult = unzipURL
            .appendingPathComponent(productName)
        catchError { [unzip, weak self] in
            if let fileManager = self?.fileManager {
                if fileManager.fileExists(atPath: unzipResult.path) {
                    try fileManager.removeItem(at: unzipResult)
                }
                // TODO: Migrate on tar ( should be faster )
                // Duration of unzip with ZIPFoundation Some.framework is 1.23 s
                // Duration of unzip with /usr/bin/unzip Some.framework is 126.29 ms
                try unzip.unzip(url.path, to: unzipURL.path)
                try fileManager.removeItem(at: url)
            }
            self?.validateArtifactExist(at: unzipResult.path)
        }
        let value = BuildProductCacheValue(key: cacheKey, path: unzipResult.path)
        completion(.result(value))
    }
    
    private func validateArtifactExist(at path: String) {
        if fileManager.fileExists(atPath: path) == false {
            catchError {
                throw BuildProductCacheStorageError.unableToFindBuildProduct(path: path)
            }
        }
    }
    
    private func gradleKey<ChecksumType: Checksum>(for cacheKey: BuildProductCacheKey<ChecksumType>) -> String {
        let string = cacheKey.productType.rawValue + "-" +
            cacheKey.productName + "-" +
            cacheKey.checksum.stringValue
        let md5String = string.md5()
        return md5String
    }
    
}
