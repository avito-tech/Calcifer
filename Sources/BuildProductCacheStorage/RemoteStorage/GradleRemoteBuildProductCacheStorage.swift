import Foundation
import ZIPFoundation
import Checksum
import Toolkit

public final class GradleRemoteBuildProductCacheStorage<ChecksumType: Checksum>: BuildProductCacheStorage {
    
    private let gradleBuildCacheClient: GradleBuildCacheClient
    private let fileManager: FileManager
    
    public init(
        gradleBuildCacheClient: GradleBuildCacheClient,
        fileManager: FileManager)
    {
        self.gradleBuildCacheClient = gradleBuildCacheClient
        self.fileManager = fileManager
    }
    
    // MARK: - FrameworkCacheStorage
    public func cached(
        for cacheKey: BuildProductCacheKey<ChecksumType>,
        completion: @escaping (BuildProductCacheResult<ChecksumType>) -> ())
    {
        let key = gradleKey(for: cacheKey)
        gradleBuildCacheClient.download(key: key) { result in
            switch result {
            case let .success(url):
                let unzipURL = url.deletingLastPathComponent()
                var productName = cacheKey.productName.deletingPathExtension()
                productName.append(cacheKey.productType.fileExtension)
                let unzipResult = unzipURL
                    .appendingPathComponent(productName)
                catchError { [weak self] in
                    if let fileManager = self?.fileManager {
                        if fileManager.fileExists(atPath: unzipResult.path) {
                            try fileManager.removeItem(at: unzipResult)
                        }
                        try fileManager.unzipItem(at: url, to: unzipURL)
                        try fileManager.removeItem(at: url)
                    }
                    self?.validateArtifactExist(at: unzipResult.path)
                }
                let value = BuildProductCacheValue(key: cacheKey, path: unzipResult.path)
                completion(.result(value))
                break
            case let .failure(error):
                Logger.verbose("Download cache for \(cacheKey) error \(error?.localizedDescription ?? "-")")
                completion(.notExist)
                break
            }
        }
    }
    
    public func add(
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
        gradleBuildCacheClient.upload(fileURL: zipFileURL, key: key) { result in
            catchError { [weak self] in
                try self?.fileManager.removeItem(at: zipFileURL)
            }
            completion()
        }
    }
    
    private func validateArtifactExist(at path: String) {
        if fileManager.fileExists(atPath: path) == false {
            catchError {
                throw BuildProductCacheStorageError.unableToFindBuildProduct(path: path)
            }
        }
    }
    
    func gradleKey(for cacheKey: BuildProductCacheKey<ChecksumType>) -> String {
        let string = cacheKey.productType.rawValue + "-" +
            cacheKey.productName + "-" +
            cacheKey.checksum.stringValue
        let md5String = string.md5()
        return md5String
    }
    
}
