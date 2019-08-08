import Foundation
import FileWatcher
import XcodeProjCache
import Toolkit

public final class WarmerManagerFactory {
    
    private let fileManager: FileManager
    private let xcodeProjCache: XcodeProjCache
    private let buildProductCacheStorageWarmerFactory: BuildProductCacheStorageWarmerFactory
    private let cleanWarmerFactory: CleanWarmerFactory
    
    public init(
        fileManager: FileManager,
        xcodeProjCache: XcodeProjCache,
        buildProductCacheStorageWarmerFactory: BuildProductCacheStorageWarmerFactory,
        cleanWarmerFactory: CleanWarmerFactory)
    {
        self.fileManager = fileManager
        self.xcodeProjCache = xcodeProjCache
        self.buildProductCacheStorageWarmerFactory = buildProductCacheStorageWarmerFactory
        self.cleanWarmerFactory = cleanWarmerFactory
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
        let cleanWarmer = DebouncingWarmer(
            warmer: cleanWarmerFactory.build(),
            delay: 20
        )
        return WarmerManagerImpl(
            warmupOperationQueue: warmupOperationQueue,
            fileWatcher: fileWatcher,
            warmers: [
                xcodeProjCacheWarmer,
                buildProductCacheStorageWarmer,
                cleanWarmer
            ],
            calciferPathProvider: calciferPathProvider
        )
    }
    
}
