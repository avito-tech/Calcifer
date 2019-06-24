import Foundation
import FileWatcher
import XcodeProjCache
import Toolkit

public final class WarmerFactory {
    
    public init() {}
    
    public func createWarmer(warmupOperationQueue: OperationQueue) -> Warmer {
        let fileWatcher = FileWatcherImpl()
        let projectFileMonitor = ProjectFileMonitor(fileWatcher: fileWatcher)
        let fileManager = FileManager.default
        let calciferPathProvider = CalciferPathProviderImpl(fileManager: fileManager)
        return WarmerImpl(
            warmupOperationQueue: warmupOperationQueue,
            projectFileMonitor: projectFileMonitor,
            calciferPathProvider: calciferPathProvider,
            xcodeProjCache: XcodeProjCacheImpl.shared
        )
    }
    
}
