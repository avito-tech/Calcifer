import Foundation
import Checksum
import Toolkit

public final class LocalBuildProductCacheStorage: BuildProductCacheStorage {

    private let fileManager: FileManager
    private let cacheDirectoryPath: String
    private let maxAgeInDaysForLocalArtifact: UInt
    
    public init(
        fileManager: FileManager,
        cacheDirectoryPath: String,
        maxAgeInDaysForLocalArtifact: UInt)
    {
        self.fileManager = fileManager
        self.cacheDirectoryPath = cacheDirectoryPath
        self.maxAgeInDaysForLocalArtifact = maxAgeInDaysForLocalArtifact
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
        let path = obtainDirectory(for: cacheKey)
            .appendingPathComponent(cacheKey.productName.deletingPathExtension())
            .appendingPathExtension(cacheKey.productType.fileExtension)
        return path
    }
    
    private func obtainDirectory<ChecksumType: Checksum>(
        for cacheKey: BuildProductCacheKey<ChecksumType>)
        -> String
    {
        return cacheDirectoryPath
            .appendingPathComponent(cacheKey.productType.shortName)
            .appendingPathComponent(cacheKey.productName.deletingPathExtension())
            .appendingPathComponent(cacheKey.checksum.stringValue)
    }
    
    public func clean(completion: @escaping () -> ()) {
        let outdateTimeInterval = TimeInterval(-Int(maxAgeInDaysForLocalArtifact) * 24 * 60 * 60)
        let outdate = Date().addingTimeInterval(outdateTimeInterval)
        fileManager.enumerate(at: cacheDirectoryPath, files: false) { productTypeDirectory in
            fileManager.enumerate(at: productTypeDirectory, files: false) { productDirectory in
                fileManager.enumerate(at: productDirectory, files: false) { checksumDirectory in
                    guard let accessDate = try? fileManager.accessDate(at: checksumDirectory)
                        else {
                            return
                        }
                    if accessDate < outdate {
                        try? fileManager.removeItem(atPath: checksumDirectory)
                    }
                }
            }
        }
        completion()
    }
    
}
