import Foundation
import FileWatcher
import XcodeBuildEnvironmentParametersParser
import Toolkit

final class WarmerManagerImpl: WarmerManager {
    
    private let warmupOperationQueue: OperationQueue
    private let fileWatcher: FileWatcher
    private let calciferPathProvider: CalciferPathProvider
    
    let warmers: [Warmer]
    
    init(
        warmupOperationQueue: OperationQueue,
        fileWatcher: FileWatcher,
        warmers: [Warmer],
        calciferPathProvider: CalciferPathProvider)
    {
        self.warmupOperationQueue = warmupOperationQueue
        self.fileWatcher = fileWatcher
        self.warmers = warmers
        self.calciferPathProvider = calciferPathProvider
    }
    
    func start() {
        guard let params = obtainEnvironmentParameters()
            else { return }
        let projectPath = params.podsProjectPath
        let pbxprojPath = projectPath
            .appendingPathComponent("project.pbxproj")
        fileWatcher.start(path: pbxprojPath)
        fileWatcher.subscribe { [weak self] event in
            self?.performOperations(for: .file(event))
        }
        performOperations(for: .initial)
    }
    
    func warmup() {
        performOperations(for: .manual)
    }
    
    private func performOperations(for event: WarmerEvent) {
        Logger.verbose("receive warmup event \(event)")
        warmers.forEach { [weak self] warmer in
            warmer.warmup(
                for: event,
                perform: { self?.warmupOperationQueue.addOperation($0) }
            )
        }
    }
    
    private func obtainEnvironmentParameters() -> XcodeBuildEnvironmentParameters? {
        let environmentFilePath = calciferPathProvider.calciferEnvironmentFilePath()
        return try? XcodeBuildEnvironmentParameters.decode(from: environmentFilePath)
    }
    
}
