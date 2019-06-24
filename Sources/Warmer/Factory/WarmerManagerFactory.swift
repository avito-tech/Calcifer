import Foundation
import FileWatcher
import XcodeProjCache
import Toolkit

public final class WarmerManagerFactory {
    
    private let fileManager: FileManager
    
    public init(fileManager: FileManager) {
        self.fileManager = fileManager
    }
    
    public func createWarmerManager(warmupOperationQueue: OperationQueue) -> WarmerManager {
        let fileWatcher = FileWatcherImpl()
        let calciferPathProvider = CalciferPathProviderImpl(fileManager: fileManager)
        let xcodeProjCacheWarmer = DebouncingWarmer(
            warmer: XcodeProjCacheWarmer(
                xcodeProjCache: XcodeProjCacheImpl.shared,
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
