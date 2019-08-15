import XcodeBuildEnvironmentParametersParser
import BuildProductCacheStorage
import CalciferConfig
import FileWatcher
import Foundation
import Toolkit

public final class CleanWarmer: Warmer {
    
    private let cleaner: Cleaner
    private let fileManager: FileManager
    private let calciferPathProvider: CalciferPathProvider
    private let calciferConfigProvider: CalciferConfigProvider
    
    public init(
        cleaner: Cleaner,
        fileManager: FileManager,
        calciferPathProvider: CalciferPathProvider,
        calciferConfigProvider: CalciferConfigProvider)
    {
        self.cleaner = cleaner
        self.fileManager = fileManager
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
        let maxAgeInDaysForLocalArtifact = config.storageConfig.maxAgeInDaysForLocalArtifact
        let operation = createOperation(
            localCacheDirectory: localCacheDirectory,
            maxAgeInDaysForLocalArtifact: maxAgeInDaysForLocalArtifact
        )
        switch event {
        case .initial:
            perform(operation)
        case .manual:
            perform(operation)
        case .file:
            return
        }
    }
    
    private func createOperation(
        localCacheDirectory: String,
        maxAgeInDaysForLocalArtifact: UInt)
        -> Operation
    {
        return BlockOperation {
            TimeProfiler.measure("Clean") {
                self.cleaner.clean(
                    logsDirectory: self.calciferPathProvider.calciferLogsDirectory(),
                    buildLogDirectory: self.calciferPathProvider.calciferBuildLogDirectory(),
                    checksumDirectory: self.calciferPathProvider.calciferChecksumDirectory(),
                    launchctlLogDirectory: self.calciferPathProvider.launchctlLogDirectory()
                )
                let buildProductCacheStorage = self.createBuildProductCacheStorage(
                    localCacheDirectory: localCacheDirectory,
                    maxAgeInDaysForLocalArtifact: maxAgeInDaysForLocalArtifact
                )
                DispatchGroup.wait { group in
                    buildProductCacheStorage.clean {
                        group.leave()
                    }
                }
            }
        }
    }
    
    func createBuildProductCacheStorage(
        localCacheDirectory: String,
        maxAgeInDaysForLocalArtifact: UInt) -> BuildProductCacheStorage
    {
        return LocalBuildProductCacheStorage(
            fileManager: fileManager,
            cacheDirectoryPath: localCacheDirectory,
            maxAgeInDaysForLocalArtifact: maxAgeInDaysForLocalArtifact
        )
    }
    
    private func obtainEnvironmentParameters() -> XcodeBuildEnvironmentParameters? {
        let environmentFilePath = calciferPathProvider.calciferEnvironmentFilePath()
        return try? XcodeBuildEnvironmentParameters.decode(from: environmentFilePath)
    }
}
