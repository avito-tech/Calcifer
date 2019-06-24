import Foundation
import XcodeBuildEnvironmentParametersParser
import FileWatcher
import XcodeProjCache
import Toolkit

final class XcodeProjCacheWarmer: Warmer {
        
    private let xcodeProjCache: XcodeProjCache
    private let calciferPathProvider: CalciferPathProvider
    
    public init(
        xcodeProjCache: XcodeProjCache,
        calciferPathProvider: CalciferPathProvider)
    {
        self.xcodeProjCache = xcodeProjCache
        self.calciferPathProvider = calciferPathProvider
    }
    
    public func warmup(for event: WarmerEvent, perform: (Operation) -> ()) {
        guard let projectPath = obtainEnvironmentParameters()?.podsProjectPath
            else { return }
        let pbxprojPath = projectPath.appendingPathComponent("project.pbxproj")
        switch event {
        case .initial:
            perform(createOperation(projectPath: projectPath))
        case .manual:
            perform(createOperation(projectPath: projectPath))
        case let .file(fileEvent):
            guard fileEvent.path == pbxprojPath else { return }
            perform(createOperation(projectPath: projectPath))
        }
        
    }

    private func createOperation(projectPath: String) -> Operation{
        return BlockOperation {
            do {
                try TimeProfiler.measure("Fill xcode project cache") { [weak self] in
                    try self?.xcodeProjCache.fillXcodeProjCache(
                        projectPath: projectPath
                    )
                }
            } catch {
                Logger.warning("XcodeProjCache warmup failed with error \(error)")
            }
        }
    }
    
    private func obtainEnvironmentParameters() -> XcodeBuildEnvironmentParameters? {
        let environmentFilePath = calciferPathProvider.calciferEnvironmentFilePath()
        return try? XcodeBuildEnvironmentParameters.decode(from: environmentFilePath)
    }
}
