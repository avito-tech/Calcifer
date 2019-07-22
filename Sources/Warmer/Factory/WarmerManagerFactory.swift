import Foundation
import FileWatcher
import XcodeProjCache
import Toolkit

public final class WarmerManagerFactory {
    
    private let fileManager: FileManager
    private let xcodeProjCache: XcodeProjCache
    private let buildProductCacheStorageWarmerFactory: BuildProductCacheStorageWarmerFactory
    
    public init(
        fileManager: FileManager,
        xcodeProjCache: XcodeProjCache,
        buildProductCacheStorageWarmerFactory: BuildProductCacheStorageWarmerFactory)
    {
        self.fileManager = fileManager
        self.xcodeProjCache = xcodeProjCache
        self.buildProductCacheStorageWarmerFactory = buildProductCacheStorageWarmerFactory
    }
    
    public func createWarmerManager(warmupOperationQueue: OperationQueue) -> WarmerManager {
        let fileWatcher = FileWatcherImpl()
        let calciferPathProvider = CalciferPathProviderImpl(fileManager: fileManager)
        let xcodeProjCacheWarmer = DebouncingWarmer(
            warmer: XcodeProjCacheWarmer(
                xcodeProjCache: xcodeProjCache,
                calciferPathProvider: calciferPathProvider,
                fileManager: fileManager
            ),
            delay: 10
        )
        let buildProductCacheStorageWarmer = DebouncingWarmer(
            warmer: buildProductCacheStorageWarmerFactory.build(),
            delay: 10
        )

        return WarmerManagerImpl(
            warmupOperationQueue: warmupOperationQueue,
            fileWatcher: fileWatcher,
            warmers: [
                xcodeProjCacheWarmer,
                buildProductCacheStorageWarmer
            ],
            calciferPathProvider: calciferPathProvider
        )
    }
    
}
