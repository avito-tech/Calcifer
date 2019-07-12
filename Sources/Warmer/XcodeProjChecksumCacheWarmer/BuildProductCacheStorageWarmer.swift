import Foundation
import XcodeProjectChecksumCalculator
import XcodeBuildEnvironmentParametersParser
import RemoteCachePreparer
import CalciferConfig
import Checksum
import Toolkit

public final class BuildProductCacheStorageWarmer: Warmer {
    
    private let configProvider: CalciferConfigProvider
    private let targetInfoProviderFactory: TargetInfoProviderFactory
    private let requiredTargetsProvider: RequiredTargetsProvider
    private let calciferPathProvider: CalciferPathProvider
    private let cacheKeyBuilder: BuildProductCacheKeyBuilder
    private let targetInfoFilter: TargetInfoFilter
    private let cacheStorageFactory: CacheStorageFactory
    
    public init(
        configProvider: CalciferConfigProvider,
        targetInfoProviderFactory: TargetInfoProviderFactory,
        requiredTargetsProvider: RequiredTargetsProvider,
        calciferPathProvider: CalciferPathProvider,
        cacheKeyBuilder: BuildProductCacheKeyBuilder,
        targetInfoFilter: TargetInfoFilter,
        cacheStorageFactory: CacheStorageFactory)
    {
        self.configProvider = configProvider
        self.targetInfoProviderFactory = targetInfoProviderFactory
        self.requiredTargetsProvider = requiredTargetsProvider
        self.calciferPathProvider = calciferPathProvider
        self.cacheKeyBuilder = cacheKeyBuilder
        self.targetInfoFilter = targetInfoFilter
        self.cacheStorageFactory = cacheStorageFactory
    }
    
    public func warmup(for event: WarmerEvent, perform: (Operation) -> ()) {
        guard let params = obtainEnvironmentParameters()
            else { return }
        guard let config = try? configProvider.obtainConfig(
            projectDirectoryPath: params.projectDirectory
        ) else { return }
        let pbxprojPath = params.podsProjectPath
            .appendingPathComponent("project.pbxproj")
        let storageConfig = config.storageConfig
        guard let gradleHost = storageConfig.gradleHost else {
            Logger.error("Gradle host is not set")
            return
        }
        switch event {
        case .initial:
            perform(createOperation(params: params, gradleHost: gradleHost))
        case .manual:
            perform(createOperation(params: params, gradleHost: gradleHost))
        case let .file(fileEvent):
            guard fileEvent.path == pbxprojPath else { return }
            perform(createOperation(params: params, gradleHost: gradleHost))
        }
        
    }
    
    private func createOperation(params: XcodeBuildEnvironmentParameters, gradleHost: String) -> Operation{
        return BlockOperation {
            do {
                try TimeProfiler.measure("Fill BuildProductCacheStorage") { [weak self] in
                    try self?.fillProductCache(params: params, gradleHost: gradleHost)
                }
            } catch {
                Logger.warning("BuildProductCacheStorage warmup failed with error \(error)")
            }
        }
    }
    
    private func fillProductCache(params: XcodeBuildEnvironmentParameters, gradleHost: String) throws -> () {
        let calciferChecksumFilePath = calciferPathProvider.calciferChecksumFilePath(for: Date())
        let requiredTargets = try requiredTargetsProvider.obtainRequiredTargets(
            params: params,
            calciferChecksumFilePath: calciferChecksumFilePath
        )
        let frameworkTargets = targetInfoFilter.frameworkTargetInfos(requiredTargets)
        let remoteStorage = try cacheStorageFactory.createRemoteBuildProductCacheStorage(
            gradleHost: gradleHost
        )
        let enumerator = CachedTargetInfosEnumerator()
        try enumerator.enumerate(
            targetInfos: frameworkTargets,
            cacheKeyBuilder: cacheKeyBuilder,
            cacheStorage: remoteStorage) { _, completion in
                completion()
            }
    }
    
    private func obtainEnvironmentParameters() -> XcodeBuildEnvironmentParameters? {
        let environmentFilePath = calciferPathProvider.calciferEnvironmentFilePath()
        return try? XcodeBuildEnvironmentParameters.decode(from: environmentFilePath)
    }
}
