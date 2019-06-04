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
    private let cacheKeyBuilder = BuildProductCacheKeyBuilder()
    private let shellCommandExecutor: ShellCommandExecutor
    private let buildTargetChecksumProviderFactory: BuildTargetChecksumProviderFactory
    private let requiredTargetsProvider: RequiredTargetsProvider
    private let cacheStorageFactory: CacheStorageFactory
    private let xcodeProjCache: XcodeProjCache
    
    
    init(
        fileManager: FileManager,
        shellCommandExecutor: ShellCommandExecutor,
        buildTargetChecksumProviderFactory: BuildTargetChecksumProviderFactory,
        requiredTargetsProvider: RequiredTargetsProvider,
        cacheStorageFactory: CacheStorageFactory,
        xcodeProjCache: XcodeProjCache)
    {
        self.fileManager = fileManager
        self.shellCommandExecutor = shellCommandExecutor
        self.buildTargetChecksumProviderFactory = buildTargetChecksumProviderFactory
        self.requiredTargetsProvider = requiredTargetsProvider
        self.cacheStorageFactory = cacheStorageFactory
        self.xcodeProjCache = xcodeProjCache
    }
    
    func prepare(
        config: CalciferConfig,
        params: XcodeBuildEnvironmentParameters,
        sourcePath: String)
        throws
    {
        let podsProjectPath = params.podsProjectPath
        
        let checksumProducer = BaseURLChecksumProducer(fileManager: fileManager)
        let paramsChecksum = try BuildParametersChecksumProducer().checksum(input: params)
        
        try params.save(to: buildEnvironmentParametersPath())
        
        let targetChecksumProvider = try TimeProfiler.measure("Calculate checksum") {
            try buildTargetChecksumProviderFactory.createBuildTargetChecksumProvider(
                podsProjectPath: podsProjectPath
            )
        }
        try targetChecksumProvider.saveChecksumToFile()
        
        guard let gradleHost = config.storageConfig?.gradleHost else {
            Logger.error("Gradle host is not set")
            return
        }
        
        let cacheStorage = try cacheStorageFactory.createMixedCacheStorage(
            gradleHost: gradleHost,
            shouldUploadCache: false
        )
        let targetInfoFilter = TargetInfoFilter(targetInfoProvider: targetChecksumProvider)
        
        let requiredTargets = try TimeProfiler.measure("Obtain required targets") {
            try requiredTargetsProvider.obtainRequiredTargets(
                params: params,
                targetInfoFilter: targetInfoFilter,
                buildParametersChecksum: paramsChecksum
            )
        }
        
        let buildArtifactIntegrator = BuildArtifactIntegrator(
            fileManager: fileManager,
            checksumProducer: checksumProducer
        )
        let artifactIntegrator = ArtifactIntegrator(
            integrator: buildArtifactIntegrator,
            cacheKeyBuilder: cacheKeyBuilder
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
            try patchedProjectBuilder.prepareAndBuildPatchedProjectIfNeeded(
                params: params,
                buildDirectoryPath: buildDirectoryPath,
                requiredTargets: requiredTargets
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
        
        try TimeProfiler.measure("Patch dSYM") {
            let dsymPatcher = createDSYMPatcher()
            try dsymPatcher.patchDSYM(
                for: integrated,
                sourcePath: sourcePath,
                fullProductName: params.fullProductName
            )
        }
        
        let intermediateFilesGenerator = IntermediateFilesGeneratorImpl(
            fileManager: fileManager
        )
        try TimeProfiler.measure("Generate intermediate files") {
            let targetsForIntermediateFiles = targetInfoFilter.frameworkTargetInfos(
                requiredTargets
            )
            try intermediateFilesGenerator.generateIntermediateFiles(
                params: params,
                buildDirectoryPath: buildDirectoryPath,
                requiredTargets: targetsForIntermediateFiles
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
            buildSourcePathProvider: buildSourcePathProvider
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
            cacheKeyBuilder: cacheKeyBuilder,
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
    
    func buildEnvironmentParametersPath() -> String {
        return fileManager
            .calciferDirectory()
            .appendingPathComponent("calciferenv.json")
    }
    
    private func obtainBuildDirectoryPath() -> String {
        return "/Users/Shared/remote-cache-build-folder.noindex/"
    }
    
}
