import Foundation
import FileWatcher
import XcodeBuildEnvironmentParametersParser
import Toolkit

final class WarmerImpl: Warmer {
    
    private let warmupOperationQueue: OperationQueue
    private let fileWatcher: FileWatcher
    private let projectFileMonitor: ProjectFileMonitor
    private let calciferPathProvider: CalciferPathProvider
    private let xcodeProjCacheWarmer: XcodeProjCacheWarmer
    
    init(
        warmupOperationQueue: OperationQueue,
        fileWatcher: FileWatcher,
        projectFileMonitor: ProjectFileMonitor,
        calciferPathProvider: CalciferPathProvider,
        xcodeProjCacheWarmer: XcodeProjCacheWarmer)
    {
        self.warmupOperationQueue = warmupOperationQueue
        self.fileWatcher = fileWatcher
        self.projectFileMonitor = projectFileMonitor
        self.calciferPathProvider = calciferPathProvider
        self.xcodeProjCacheWarmer = xcodeProjCacheWarmer
    }
    
    func start() {
        guard let params = obtainEnvironmentParameters()
            else { return }
        let projectPath = params.podsProjectPath
        fileWatcher.start(path: projectPath)
        projectFileMonitor.start(projectPath: projectPath) { [weak self] in
            self?.warmup()
        }
        warmup()
    }
    
    func warmup() {
        guard let params = obtainEnvironmentParameters()
            else { return }
        performOperation { [weak self] in
            self?.performWarmup(projectPath: params.podsProjectPath)
        }
    }
    
    private func obtainEnvironmentParameters() -> XcodeBuildEnvironmentParameters? {
        let environmentFilePath = calciferPathProvider.calciferEnvironmentFilePath()
        return try? XcodeBuildEnvironmentParameters.decode(from: environmentFilePath)
    }
    
    private func performOperation(
        priority: Operation.QueuePriority = .high,
        action: @escaping () -> ())
    {
        let operation = BlockOperation(block: action)
        operation.queuePriority = priority
        warmupOperationQueue.addOperation(operation)
    }
    
    private func performWarmup(projectPath: String) {
        do {
            Logger.verbose("Perform warmup for \(projectPath)")
            try xcodeProjCacheWarmer.warmup(projectPath: projectPath)
            Logger.verbose("Warmup for \(projectPath) completed")
        } catch {
            Logger.warning("Warmup failed with error \(error)")
        }
    }
    
}
