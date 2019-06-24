import Foundation
import FileWatcher
import XcodeProjCache
import Toolkit

public final class WarmerFactory {
    
    public init() {}
    
    public func createWarmer(warmupOperationQueue: OperationQueue) -> Warmer {
        let fileWatcher = FileWatcherImpl()
        let projectFileMonitor = ProjectFileMonitor(fileEventNotifier: fileWatcher)
        let fileManager = FileManager.default
        let calciferPathProvider = CalciferPathProviderImpl(fileManager: fileManager)
        let xcodeProjCacheWarmer = XcodeProjCacheWarmerImpl(
            xcodeProjCache: XcodeProjCacheImpl.shared
        )
        return WarmerImpl(
            warmupOperationQueue: warmupOperationQueue,
            fileWatcher: fileWatcher,
            projectFileMonitor: projectFileMonitor,
            calciferPathProvider: calciferPathProvider,
            xcodeProjCacheWarmer: xcodeProjCacheWarmer
        )
    }
    
}
