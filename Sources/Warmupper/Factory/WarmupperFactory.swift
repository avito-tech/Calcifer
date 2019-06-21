import Foundation
import FileWatcher
import XcodeProjCache
import Toolkit

public final class WarmupperFactory {
    
    public init() {}
    
    public func createWarmupper(warmupOperationQueue: OperationQueue) -> Warmupper {
        let fileWatcher = FileWatcherImpl()
        let projectFileMonitor = ProjectFileMonitor(fileWatcher: fileWatcher)
        let fileManager = FileManager.default
        let calciferPathProvider = CalciferPathProviderImpl(fileManager: fileManager)
        return WarmupperImpl(
            warmupOperationQueue: warmupOperationQueue,
            projectFileMonitor: projectFileMonitor,
            calciferPathProvider: calciferPathProvider,
            xcodeProjCache: XcodeProjCacheImpl.shared
        )
    }
    
}
