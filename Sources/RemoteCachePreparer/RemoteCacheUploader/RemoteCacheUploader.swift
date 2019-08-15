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
    private let targetInfoFilter: TargetInfoFilter
    private let requiredTargetsProvider: RequiredTargetsProvider
    private let cacheStorageFactory: CacheStorageFactory
    
    init(
        fileManager: FileManager,
        calciferPathProvider: CalciferPathProvider,
        checksumProducer: BaseURLChecksumProducer,
        cacheKeyBuilder: BuildProductCacheKeyBuilder,
        targetInfoFilter: TargetInfoFilter,
        requiredTargetsProvider: RequiredTargetsProvider,
        cacheStorageFactory: CacheStorageFactory)
    {
        self.fileManager = fileManager
        self.calciferPathProvider = calciferPathProvider
        self.checksumProducer = checksumProducer
        self.cacheKeyBuilder = cacheKeyBuilder
        self.targetInfoFilter = targetInfoFilter
        self.requiredTargetsProvider = requiredTargetsProvider
        self.cacheStorageFactory = cacheStorageFactory
    }
    
    func upload(
        config: CalciferConfig,
        params: XcodeBuildEnvironmentParameters)
        throws
    {
        
        let storageConfig = config.storageConfig
        guard let gradleHost = storageConfig.gradleHost else {
            Logger.error("Gradle host is not set")
            return
        }
        
        let localStorage = cacheStorageFactory.createLocalBuildProductCacheStorage(
            localCacheDirectoryPath: storageConfig.localCacheDirectory,
            maxAgeInDaysForLocalArtifact: storageConfig.maxAgeInDaysForLocalArtifact
        )
        let remoteStorage = try cacheStorageFactory.createRemoteBuildProductCacheStorage(
            gradleHost: gradleHost
        )
        let calciferChecksumFilePath = calciferPathProvider.calciferChecksumFilePath(for: Date())
        let requiredTargets = try TimeProfiler.measure("Obtain required targets") {
            try requiredTargetsProvider.obtainRequiredTargets(
                params: params,
                calciferChecksumFilePath: calciferChecksumFilePath
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
