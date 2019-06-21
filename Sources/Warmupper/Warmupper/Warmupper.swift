import Foundation
import FileWatcher
import XcodeBuildEnvironmentParametersParser
import XcodeProjCache
import Toolkit

public protocol Warmupper {
    func start()
    func warmup()
}

final class WarmupperImpl: Warmupper {
    
    private let warmupOperationQueue: OperationQueue
    private let projectFileMonitor: ProjectFileMonitor
    private let calciferPathProvider: CalciferPathProvider
    private let xcodeProjCache: XcodeProjCache
    
    init(
        warmupOperationQueue: OperationQueue,
        projectFileMonitor: ProjectFileMonitor,
        calciferPathProvider: CalciferPathProvider,
        xcodeProjCache: XcodeProjCache)
    {
        self.warmupOperationQueue = warmupOperationQueue
        self.projectFileMonitor = projectFileMonitor
        self.calciferPathProvider = calciferPathProvider
        self.xcodeProjCache = xcodeProjCache
    }
    
    func start() {
        guard let params = obtainEnvironmentParameters()
            else { return }
        projectFileMonitor.start(projectPath: params.podsProjectPath) { [weak self] in
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
            try TimeProfiler.measure("Fill xcode project cache") {
                try xcodeProjCache.fillXcodeProjCache(
                    projectPath: projectPath
                )
            }
            Logger.verbose("Warmup for \(projectPath) completed")
        } catch {
            Logger.warning("Warmup failed with error \(error)")
        }
    }
    
}
