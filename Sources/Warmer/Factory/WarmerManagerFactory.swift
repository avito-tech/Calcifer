import Foundation
import FileWatcher
import XcodeProjCache
import Toolkit

public final class WarmerManagerFactory {
    
    private let fileManager: FileManager
    private let xcodeProjCache: XcodeProjCache
    
    public init(
        fileManager: FileManager,
        xcodeProjCache: XcodeProjCache)
    {
        self.fileManager = fileManager
        self.xcodeProjCache = xcodeProjCache
    }
    
    public func createWarmerManager(warmupOperationQueue: OperationQueue) -> WarmerManager {
        let fileWatcher = FileWatcherImpl()
        let calciferPathProvider = CalciferPathProviderImpl(fileManager: fileManager)
        let xcodeProjCacheWarmer = DebouncingWarmer(
            warmer: XcodeProjCacheWarmer(
                xcodeProjCache: xcodeProjCache,
                calciferPathProvider: calciferPathProvider
            ),
            delay: 1
        )
        return WarmerManagerImpl(
            warmupOperationQueue: warmupOperationQueue,
            fileWatcher: fileWatcher,
            warmers: [xcodeProjCacheWarmer],
            calciferPathProvider: calciferPathProvider
        )
    }
    
}
