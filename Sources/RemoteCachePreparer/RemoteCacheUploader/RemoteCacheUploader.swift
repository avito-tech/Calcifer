import Foundation
import XcodeBuildEnvironmentParametersParser
import XcodeProjectChecksumCalculator
import BuildProductCacheStorage
import XcodeProjectBuilder
import XcodeProjectPatcher
import CalciferConfig
import BuildArtifacts
import DSYMSymbolizer
import ShellCommand
import Checksum
import Toolkit

final class RemoteCacheUploader {
    
    private let fileManager: FileManager
    private let calciferPathProvider: CalciferPathProvider
    private let checksumProducer: BaseURLChecksumProducer
    private let cacheKeyBuilder: BuildProductCacheKeyBuilder
    private let targetInfoProviderFactory: TargetInfoProviderFactory
    private let requiredTargetsProvider: RequiredTargetsProvider
    private let cacheStorageFactory: CacheStorageFactory
    
    init(
        fileManager: FileManager,
        calciferPathProvider: CalciferPathProvider,
        checksumProducer: BaseURLChecksumProducer,
        cacheKeyBuilder: BuildProductCacheKeyBuilder,
        targetInfoProviderFactory: TargetInfoProviderFactory,
        requiredTargetsProvider: RequiredTargetsProvider,
        cacheStorageFactory: CacheStorageFactory)
    {
        self.fileManager = fileManager
        self.calciferPathProvider = calciferPathProvider
        self.checksumProducer = checksumProducer
        self.cacheKeyBuilder = cacheKeyBuilder
        self.targetInfoProviderFactory = targetInfoProviderFactory
        self.requiredTargetsProvider = requiredTargetsProvider
        self.cacheStorageFactory = cacheStorageFactory
    }
    
    func upload(
        config: CalciferConfig,
        params: XcodeBuildEnvironmentParameters)
        throws
    {
        
        let podsProjectPath = params.podsProjectPath
        
        let paramsChecksum = try BuildParametersChecksumProducer().checksum(input: params)
        
        let targetInfoProvider = try TimeProfiler.measure("Calculate checksum") {
            try targetInfoProviderFactory.targetChecksumProvider(
                projectPath: podsProjectPath
            )
        }
        targetInfoProvider.saveChecksum(
            to: calciferPathProvider.calciferChecksumFilePath(for: Date())
        )
        
        let storageConfig = config.storageConfig
        guard let gradleHost = storageConfig.gradleHost else {
            Logger.error("Gradle host is not set")
            return
        }
        
        let localStorage = cacheStorageFactory.createLocalBuildProductCacheStorage(
            localCacheDirectoryPath: storageConfig.localCacheDirectory
        )
        let remoteStorage = try cacheStorageFactory.createRemoteBuildProductCacheStorage(
            gradleHost: gradleHost
        )
        let targetInfoFilter = TargetInfoFilter(targetInfoProvider: targetInfoProvider)
        let requiredTargets = try TimeProfiler.measure("Obtain required targets") {
            try requiredTargetsProvider.obtainRequiredTargets(
                params: params,
                targetInfoFilter: targetInfoFilter,
                buildParametersChecksum: paramsChecksum
            )
        }
        
        let frameworkTargets = targetInfoFilter.frameworkTargetInfos(requiredTargets)
        
        let enumerator = CachedTargetInfosEnumerator()
        try enumerator.enumerate(
            targetInfos: frameworkTargets,
            cacheKeyBuilder: cacheKeyBuilder,
            cacheStorage: localStorage) { cachedTargetInfo, completion in
                remoteStorage.add(
                    cacheKey: cachedTargetInfo.frameworkCacheValue.key,
                    at: cachedTargetInfo.frameworkCacheValue.path,
                    completion: {
                        remoteStorage.add(
                            cacheKey: cachedTargetInfo.dSYMCacheValue.key,
                            at: cachedTargetInfo.dSYMCacheValue.path,
                            completion: completion
                        )
                    }
                )
        }
    }
    
}
