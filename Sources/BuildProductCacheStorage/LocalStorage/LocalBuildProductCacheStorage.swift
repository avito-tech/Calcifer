import Foundation
import Checksum
import Toolkit

public final class LocalBuildProductCacheStorage: BuildProductCacheStorage {

    private let fileManager: FileManager
    private let cacheDirectoryPath: String
    
    public init(fileManager: FileManager, cacheDirectoryPath: String) {
        self.fileManager = fileManager
        self.cacheDirectoryPath = cacheDirectoryPath
    }
    
    // MARK: - FrameworkCacheStorage
    public func cached<ChecksumType: Checksum>(
        for cacheKey: BuildProductCacheKey<ChecksumType>,
        completion: @escaping (BuildProductCacheResult<ChecksumType>) -> ())
    {
        let entryURL = url(to: cacheKey)
        if fileManager.directoryExist(at: entryURL) {
            let value = BuildProductCacheValue(key: cacheKey, path: entryURL.path)
            completion(.result(value))
            return
        }
        completion(.notExist)
    }
    
    public func add<ChecksumType: Checksum>(
        cacheKey: BuildProductCacheKey<ChecksumType>,
        at path: String,
        completion: @escaping () -> ())
    {
        let artifactURL = URL(fileURLWithPath: path)
        let entryURL = url(to: cacheKey)
        
        let entryFolderURL = entryURL.deletingLastPathComponent()
        catchError {
            if fileManager.directoryExist(at: entryFolderURL) {
                try fileManager.removeItem(at: entryFolderURL)
            }
            try fileManager.createDirectory(
                at: entryFolderURL,
                withIntermediateDirectories: true
            )
            
            try fileManager.copyItem(at: artifactURL, to: entryURL)
        }
        completion()
    }
    
    @inline(__always) private func url<ChecksumType: Checksum>(
        to cacheKey: BuildProductCacheKey<ChecksumType>)
        -> URL
    {
        return URL(fileURLWithPath: path(to: cacheKey))
    }
    
    private func path<ChecksumType: Checksum>(to cacheKey: BuildProductCacheKey<ChecksumType>) -> String {
        var path = cacheDirectoryPath
            .appendingPathComponent(cacheKey.productType.rawValue)
            .appendingPathComponent(cacheKey.productName.deletingPathExtension())
            .appendingPathComponent(cacheKey.checksum.stringValue)
            .appendingPathComponent(cacheKey.productName.deletingPathExtension())
        path.append(cacheKey.productType.fileExtension)
        return path
    }
    
}
