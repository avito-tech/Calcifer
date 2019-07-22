import Foundation
import XcodeProjectChecksumCalculator
import XcodeBuildEnvironmentParametersParser
import RemoteCachePreparer
import CalciferConfig
import Checksum
import Toolkit

public final class BuildProductCacheStorageWarmer: Warmer {
    
    private let configProvider: CalciferConfigProvider
    private let requiredTargetsProvider: RequiredTargetsProvider
    private let calciferPathProvider: CalciferPathProvider
    private let cacheKeyBuilder: BuildProductCacheKeyBuilder
    private let targetInfoFilter: TargetInfoFilter
    private let cacheStorageFactory: CacheStorageFactory
    private let fileManager: FileManager
    
    public init(
        configProvider: CalciferConfigProvider,
        requiredTargetsProvider: RequiredTargetsProvider,
        calciferPathProvider: CalciferPathProvider,
        cacheKeyBuilder: BuildProductCacheKeyBuilder,
        targetInfoFilter: TargetInfoFilter,
        cacheStorageFactory: CacheStorageFactory,
        fileManager: FileManager)
    {
        self.configProvider = configProvider
        self.requiredTargetsProvider = requiredTargetsProvider
        self.calciferPathProvider = calciferPathProvider
        self.cacheKeyBuilder = cacheKeyBuilder
        self.targetInfoFilter = targetInfoFilter
        self.cacheStorageFactory = cacheStorageFactory
        self.fileManager = fileManager
    }
    
    public func warmup(for event: WarmerEvent, perform: @escaping (Operation) -> ()) {
        guard let params = obtainEnvironmentParameters()
            else { return }
        guard let config = try? configProvider.obtainConfig(
            projectDirectoryPath: params.projectDirectory
        ) else { return }
        let pbxprojPath = params.podsProjectPath
            .appendingPathComponent("project.pbxproj")
        guard fileManager.fileExists(atPath: pbxprojPath) else {
            Logger.warning("pbxproj file doesn't exist at path \(pbxprojPath)")
            return
        }
        let storageConfig = config.storageConfig
        guard let gradleHost = storageConfig.gradleHost else {
            Logger.error("Gradle host is not set")
            return
        }
        let localCacheDirectoryPath = storageConfig.localCacheDirectory
        let performWarmup = { [weak self] in
            guard let strongSelf = self else { return }
            perform(
                strongSelf.createOperation(
                    params: params,
                    localCacheDirectoryPath: localCacheDirectoryPath,
                    gradleHost: gradleHost
                )
            )
        }
        switch event {
        case .initial:
            performWarmup()
        case .manual:
            performWarmup()
        case let .file(fileEvent):
            guard fileEvent.path == pbxprojPath else { return }
            performWarmup()
        }
        
    }
    
    private func createOperation(
        params: XcodeBuildEnvironmentParameters,
        localCacheDirectoryPath: String,
        gradleHost: String)
        -> Operation
    {
        return BlockOperation {
            do {
                try TimeProfiler.measure("Fill BuildProductCacheStorage") { [weak self] in
                    try self?.fillProductCache(
                        params: params,
                        localCacheDirectoryPath: localCacheDirectoryPath,
                        gradleHost: gradleHost
                    )
                }
            } catch {
                Logger.warning("BuildProductCacheStorage warmup failed with error \(error)")
            }
        }
    }
    
    private func fillProductCache(
        params: XcodeBuildEnvironmentParameters,
        localCacheDirectoryPath: String,
        gradleHost: String)
        throws
    {
        let calciferChecksumFilePath = calciferPathProvider.calciferChecksumFilePath(for: Date())
        let requiredTargets = try requiredTargetsProvider.obtainRequiredTargets(
            params: params,
            calciferChecksumFilePath: calciferChecksumFilePath,
            validateChecksumHolder: true
        )
        let frameworkTargets = targetInfoFilter.frameworkTargetInfos(requiredTargets)
        let storage = try cacheStorageFactory.createMixedCacheStorage(
            localCacheDirectoryPath: localCacheDirectoryPath,
            gradleHost: gradleHost,
            shouldUpload: false
        )
        let enumerator = CachedTargetInfosEnumerator()
        try enumerator.enumerate(
            targetInfos: frameworkTargets,
            cacheKeyBuilder: cacheKeyBuilder,
            cacheStorage: storage)
        { _, completion in
                completion()
        }
    }
    
    private func obtainEnvironmentParameters() -> XcodeBuildEnvironmentParameters? {
        let environmentFilePath = calciferPathProvider.calciferEnvironmentFilePath()
        return try? XcodeBuildEnvironmentParameters.decode(from: environmentFilePath)
    }
}
