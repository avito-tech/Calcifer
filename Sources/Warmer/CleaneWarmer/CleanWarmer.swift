import XcodeBuildEnvironmentParametersParser
import CalciferConfig
import FileWatcher
import Foundation
import Toolkit

public final class CleanWarmer: Warmer {
    
    private let cleaner: Cleaner
    private let calciferPathProvider: CalciferPathProvider
    private let calciferConfigProvider: CalciferConfigProvider
    
    public init(
        cleaner: Cleaner,
        calciferPathProvider: CalciferPathProvider,
        calciferConfigProvider: CalciferConfigProvider)
    {
        self.cleaner = cleaner
        self.calciferPathProvider = calciferPathProvider
        self.calciferConfigProvider = calciferConfigProvider
    }
    
    public func warmup(for event: WarmerEvent, perform: (Operation) -> ()) {
        guard let params = obtainEnvironmentParameters()
            else { return }
        guard let config = try? calciferConfigProvider.obtainConfig(
            projectDirectoryPath: params.projectDirectory
        ) else { return }
        let localCacheDirectory = config.storageConfig.localCacheDirectory
        switch event {
        case .initial:
            perform(createOperation(localCacheDirectory: localCacheDirectory))
        case .manual:
            perform(createOperation(localCacheDirectory: localCacheDirectory))
        case .file:
            return
        }
    }
    
    private func createOperation(localCacheDirectory: String) -> Operation{
        return BlockOperation {
            TimeProfiler.measure("Clean") {
                self.cleaner.clean(
                    logsDirectory: self.calciferPathProvider.calciferLogsDirectory(),
                    buildLogDirectory: self.calciferPathProvider.calciferBuildLogDirectory(),
                    checksumDirectory: self.calciferPathProvider.calciferChecksumDirectory(),
                    launchctlLogDirectory: self.calciferPathProvider.launchctlLogDirectory(),
                    localCacheDirectory: localCacheDirectory
                )
            }
        }
    }
    
    private func obtainEnvironmentParameters() -> XcodeBuildEnvironmentParameters? {
        let environmentFilePath = calciferPathProvider.calciferEnvironmentFilePath()
        return try? XcodeBuildEnvironmentParameters.decode(from: environmentFilePath)
    }
}
