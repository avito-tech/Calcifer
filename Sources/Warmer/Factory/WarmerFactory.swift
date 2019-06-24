import Foundation
import FileWatcher
import XcodeProjCache
import Toolkit

public final class WarmerFactory {
    
    private let fileManager: FileManager
    
    public init(fileManager: FileManager) {
        self.fileManager = fileManager
    }
    
    public func createWarmer(warmupOperationQueue: OperationQueue) -> Warmer {
        let fileWatcher = FileWatcherImpl()
        let projectFileMonitor = ProjectFileMonitor(fileEventNotifier: fileWatcher)
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
