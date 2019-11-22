import Foundation
import XcodeBuildEnvironmentParametersParser
import XcodeProjectChecksumCalculator
import BuildProductCacheStorage
import XcodeProjectBuilder
import XcodeProjectPatcher
import StatisticLogger
import CalciferConfig
import XcodeProjCache
import BuildArtifacts
import DSYMSymbolizer
import ShellCommand
import Checksum
import Toolkit

final class RemoteCachePreparer {
    
    private let fileManager: FileManager
    private let calciferPathProvider: CalciferPathProvider
    private let cacheKeyBuilde: BuildProductCacheKeyBuilder
    private let targetInfoFilter: TargetInfoFilter
    private let shellCommandExecutor: ShellCommandExecutor
    private let requiredTargetsProvider: RequiredTargetsProvider
    private let cacheStorageFactory: CacheStorageFactory
    private let xcodeProjCache: XcodeProjCache
    private let artifactBuildSourcePathCache: ArtifactBuildSourcePathCache
    private let targetBuildArtifactMetaInfoManager: TargetBuildArtifactMetaInfoManager
    
    init(
        fileManager: FileManager,
        calciferPathProvider: CalciferPathProvider,
        cacheKeyBuilde: BuildProductCacheKeyBuilder,
        targetInfoFilter: TargetInfoFilter,
        shellCommandExecutor: ShellCommandExecutor,
        requiredTargetsProvider: RequiredTargetsProvider,
        cacheStorageFactory: CacheStorageFactory,
        xcodeProjCache: XcodeProjCache,
        artifactBuildSourcePathCache: ArtifactBuildSourcePathCache,
        targetBuildArtifactMetaInfoManager: TargetBuildArtifactMetaInfoManager)
    {
        self.fileManager = fileManager
        self.calciferPathProvider = calciferPathProvider
        self.cacheKeyBuilde = cacheKeyBuilde
        self.targetInfoFilter = targetInfoFilter
        self.shellCommandExecutor = shellCommandExecutor
        self.requiredTargetsProvider = requiredTargetsProvider
        self.cacheStorageFactory = cacheStorageFactory
        self.xcodeProjCache = xcodeProjCache
        self.artifactBuildSourcePathCache = artifactBuildSourcePathCache
        self.targetBuildArtifactMetaInfoManager = targetBuildArtifactMetaInfoManager
    }
    
    func prepare(
        config: CalciferConfig,
        params: XcodeBuildEnvironmentParameters,
        checksumProducer: BaseURLChecksumProducer,
        sourcePath: String)
        throws
    {
        try params.save(to: calciferPathProvider.calciferEnvironmentFilePath())
        
        let storageConfig = config.storageConfig
        
        let cacheStorage: BuildProductCacheStorage
        
        let shouldUploadCache = storageConfig.shouldUpload
        let localCacheDirectoryPath = storageConfig.localCacheDirectory
        
        if let gradleHost = storageConfig.gradleHost {
            cacheStorage = try cacheStorageFactory.createMixedCacheStorage(
                localCacheDirectoryPath: localCacheDirectoryPath,
                maxAgeInDaysForLocalArtifact: storageConfig.maxAgeInDaysForLocalArtifact,
                gradleHost: gradleHost,
                shouldUpload: shouldUploadCache
            )
        } else {
            Logger.info("Gradle host is not set")
            cacheStorage = cacheStorageFactory.createLocalBuildProductCacheStorage(
                localCacheDirectoryPath: localCacheDirectoryPath,
                maxAgeInDaysForLocalArtifact: storageConfig.maxAgeInDaysForLocalArtifact
            )
        }

        let calciferChecksumFilePath = calciferPathProvider.calciferChecksumFilePath(for: Date())
        let requiredTargets = try TimeProfiler.measure("Obtain required targets") {
            try requiredTargetsProvider.obtainRequiredTargets(
                params: params,
                calciferChecksumFilePath: calciferChecksumFilePath
            )
        }
        
        let buildArtifactIntegrator = BuildArtifactIntegrator(
            fileManager: fileManager,
            checksumProducer: checksumProducer,
            targetBuildArtifactMetaInfoManager: targetBuildArtifactMetaInfoManager
        )
        let artifactIntegrator = ArtifactIntegrator(
            integrator: buildArtifactIntegrator,
            cacheKeyBuilder: cacheKeyBuilde
        )
        
        let buildDirectoryPath = obtainBuildDirectoryPath()
        
        try TimeProfiler.measure("Remove XCBuildData Directory") {
            let buildDataDirectoryPath = buildDirectoryPath
                .appendingPathComponent("XCBuildData")
            if fileManager.directoryExist(at: buildDataDirectoryPath) {
                try fileManager.removeItem(atPath: buildDataDirectoryPath)
            }
        }

        try TimeProfiler.measure("Prepare and build patched project if needed") {
            let patchedProjectBuilder = try createPatchedProjectBuilder(
                config: config,
                targetInfoFilter: targetInfoFilter,
                cacheStorage: cacheStorage,
                checksumProducer: checksumProducer,
                artifactIntegrator: artifactIntegrator
            )
            let buildLogDirectory = calciferPathProvider.calciferBuildLogDirectory()
            try patchedProjectBuilder.prepareAndBuildPatchedProjectIfNeeded(
                params: params,
                buildDirectoryPath: buildDirectoryPath,
                requiredTargets: requiredTargets,
                buildLogDirectory: buildLogDirectory
            )
        }
        
        let targetInfosForIntegration = targetInfoFilter.frameworkTargetInfos(requiredTargets)
        let integrated = try TimeProfiler.measure("Integrate artifacts to Derived Data") {
            try artifactIntegrator.integrateArtifacts(
                checksumProducer: checksumProducer,
                cacheStorage: cacheStorage,
                targetInfos: targetInfosForIntegration,
                to: params.configurationBuildDirectory
            )
        }
        
        if let fullProductName = params.fullProductName {
            try TimeProfiler.measure("Patch dSYM") {
                let dsymPatcher = createDSYMPatcher()
                try dsymPatcher.patchDSYM(
                    for: integrated,
                    sourcePath: sourcePath,
                    fullProductName: fullProductName
                )
            }
        }
        
        let intermediateFilesGenerator = IntermediateFilesGeneratorImpl(
            fileManager: fileManager
        )
        try TimeProfiler.measure("Generate intermediate files") {
            try intermediateFilesGenerator.generateIntermediateFiles(
                for: integrated,
                params: params,
                buildDirectoryPath: buildDirectoryPath
            )
        }
        
    }
    
    private func createDSYMPatcher() -> DSYMPatcher {
        let symbolizer = createDSYMSymbolizer()
        let binaryPathProvider = BinaryPathProvider(fileManager: fileManager)
        let symbolTableProvider = SymbolTableProviderImpl(
            shellCommandExecutor: shellCommandExecutor
        )
        let buildSourcePathProvider = BuildSourcePathProviderImpl(
            symbolTableProvider: symbolTableProvider,
            fileManager: fileManager
        )
        let dsymPatcher = DSYMPatcher(
            symbolizer: symbolizer,
            binaryPathProvider: binaryPathProvider,
            buildSourcePathProvider: buildSourcePathProvider,
            artifactBuildSourcePathCache: artifactBuildSourcePathCache
        )
        return dsymPatcher
    }
    
    private func createDSYMSymbolizer() -> DSYMSymbolizer {
        let dwarfUUIDProvider = DWARFUUIDProviderImpl(shellCommandExecutor: shellCommandExecutor)
        let symbolizer = DSYMSymbolizer(
            dwarfUUIDProvider: dwarfUUIDProvider,
            fileManager: fileManager
        )
        return symbolizer
    }
    
    private func createPatchedProjectBuilder(
        config: CalciferConfig,
        targetInfoFilter: TargetInfoFilter,
        cacheStorage: BuildProductCacheStorage,
        checksumProducer: BaseURLChecksumProducer,
        artifactIntegrator: ArtifactIntegrator)
        throws -> PatchedProjectBuilder
    {
        let artifactProvider = TargetBuildArtifactProvider(
            fileManager: fileManager
        )
        let buildLogLevel: BuildLogLevel = config.buildConfig?.buildLogLevel ?? .info
        let outputFilter = XcodeProjectBuilderOutputFilterImpl(
            buildLogLevel: buildLogLevel
        )
        let outputHandler = XcodeProjectBuilderOutputHandlerImpl(
            fileManager: fileManager,
            observableStandardStream: ObservableStandardStream.shared,
            outputFilter: outputFilter
        )
        let builder = XcodeProjectBuilder(
            shellExecutor: shellCommandExecutor,
            outputHandler: outputHandler
        )
        let patcher = XcodeProjectPatcher(
            xcodeProjCache: xcodeProjCache,
            fileManager: fileManager
        )
        let xcodeCommandLineVersionProvider = XcodeCommandLineToolVersionProvider(
            shellExecutor: shellCommandExecutor
        )
        let statisticLogger = try createStatisticLogger(config: config)
        return PatchedProjectBuilder(
            cacheStorage: cacheStorage,
            checksumProducer: checksumProducer,
            cacheKeyBuilder: cacheKeyBuilde,
            patcher: patcher,
            builder: builder,
            artifactIntegrator: artifactIntegrator,
            targetInfoFilter: targetInfoFilter,
            artifactProvider: artifactProvider,
            xcodeCommandLineVersionProvider: xcodeCommandLineVersionProvider,
            statisticLogger: statisticLogger
        )
    }
    
    private func createStatisticLogger(config: CalciferConfig) throws -> CacheHitStatisticLogger {
        var loggers = [CacheHitStatisticLogger]()
        if let graphiteConfig = config.statisticLoggerConfig?.graphiteConfig {
            let statisticLoggerFactory = CacheHitStatisticLoggerFactory()
            let graphiteCacheHitStatisticLogger = try statisticLoggerFactory.createGraphiteCacheHitStatisticLogger(
                host: graphiteConfig.host,
                port: graphiteConfig.port,
                rootKey: graphiteConfig.rootKey
            )
            loggers.append(graphiteCacheHitStatisticLogger)
        }
        let aggregateLogger = AggregateCacheHitStatsticLogger(
            loggers: loggers
        )
        return aggregateLogger
    }
    
    private func obtainBuildDirectoryPath() -> String {
        return "/Users/Shared/remote-cache-build-folder.noindex/"
    }
    
}
