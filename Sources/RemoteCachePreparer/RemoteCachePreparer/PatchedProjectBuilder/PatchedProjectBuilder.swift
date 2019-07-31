import Foundation
import XcodeBuildEnvironmentParametersParser
import XcodeProjectChecksumCalculator
import BuildProductCacheStorage
import XcodeProjectBuilder
import XcodeProjectPatcher
import StatisticLogger
import BuildArtifacts
import ShellCommand
import Checksum
import Toolkit

public final class PatchedProjectBuilder {
    
    private let cacheStorage: BuildProductCacheStorage
    private let checksumProducer: BaseURLChecksumProducer
    private let cacheKeyBuilder: BuildProductCacheKeyBuilder
    private let patcher: XcodeProjectPatcher
    private let builder: XcodeProjectBuilder
    private let artifactIntegrator: ArtifactIntegrator
    private let targetInfoFilter: TargetInfoFilter
    private let artifactProvider: TargetBuildArtifactProvider
    private let xcodeCommandLineVersionProvider: XcodeCommandLineToolVersionProvider
    private let statisticLogger: CacheHitStatisticLogger
    
    init(
        cacheStorage: BuildProductCacheStorage,
        checksumProducer: BaseURLChecksumProducer,
        cacheKeyBuilder: BuildProductCacheKeyBuilder,
        patcher: XcodeProjectPatcher,
        builder: XcodeProjectBuilder,
        artifactIntegrator: ArtifactIntegrator,
        targetInfoFilter: TargetInfoFilter,
        artifactProvider: TargetBuildArtifactProvider,
        xcodeCommandLineVersionProvider: XcodeCommandLineToolVersionProvider,
        statisticLogger: CacheHitStatisticLogger)
    {
        self.cacheStorage = cacheStorage
        self.checksumProducer = checksumProducer
        self.cacheKeyBuilder = cacheKeyBuilder
        self.patcher = patcher
        self.builder = builder
        self.artifactIntegrator = artifactIntegrator
        self.targetInfoFilter = targetInfoFilter
        self.artifactProvider = artifactProvider
        self.xcodeCommandLineVersionProvider = xcodeCommandLineVersionProvider
        self.statisticLogger = statisticLogger
    }
    
    public func prepareAndBuildPatchedProjectIfNeeded(
        params: XcodeBuildEnvironmentParameters,
        buildDirectoryPath: String,
        requiredTargets: [TargetInfo<BaseChecksum>],
        buildLogDirectory: String?,
        shouldGenerateDSYMs: Bool
        )
        throws -> [TargetInfo<BaseChecksum>]
    {
        try validateVersion(params: params)
        
        let podsProjectPath = params.podsProjectPath
        let patchedProjectPath = params.patchedProjectPath
        let cacheBuildPath = buildDirectoryPath
            .appendingPathComponent("\(params.configuration)-\(params.platformName)")
        
        let requiredFramework = targetInfoFilter.frameworkTargetInfos(requiredTargets)
        
        let targetsForBuild = try TimeProfiler.measure("Obtain targets for build") {
            try obtainTargetsForBuild(
                cacheStorage: cacheStorage,
                allRequiredTargetInfos: requiredTargets,
                requiredFramework: requiredFramework,
                dSYMRequired: shouldGenerateDSYMs
            )
        }
        let targetNamesForBuild = targetsForBuild.map { $0.targetName }
        
        let targetInfosForPatchedProjectIntegration = targetInfosForIntegrationToPatchedProject(
            requiredTargets: requiredTargets,
            targetsForBuild: targetsForBuild
        )
        
        let entries = targetInfosForPatchedProjectIntegration.map {
            CacheHitRationEntry(moduleName: $0.targetName, resolution: .hit)
        } + targetNamesForBuild.map {
            CacheHitRationEntry(moduleName: $0, resolution: .miss)
        }
        
        let statistic = CacheHitRationStatistic(
            entries: entries
        )
        try statisticLogger.logStatisticCache(
            statistic,
            params: params
        )
        
        // If we do not need to store an artifact, then we don’t need to build it.
        // The bundle targets are filtered out because they are already inside some framework (cocoapods does this)
        // If any file in the bundle has changed, then all dependencies will be rebuilt.
        // Because their checksum has changed.
        if !targetNamesForBuild.isEmpty {
            Logger.verbose("Target for build: \(targetNamesForBuild)")
            try TimeProfiler.measure("Patch project") {
                try patchProject(
                    podsProjectPath: podsProjectPath,
                    patchedProjectPath: patchedProjectPath,
                    targets: targetNamesForBuild,
                    shouldGenerateDSYMs: shouldGenerateDSYMs,
                    params: params
                )
            }
            
            try TimeProfiler.measure("Integrate artifacts to build directory") {
                try artifactIntegrator.integrateArtifacts(
                    checksumProducer: checksumProducer,
                    cacheStorage: cacheStorage,
                    targetInfos: targetInfosForPatchedProjectIntegration,
                    to: cacheBuildPath,
                    dSYMRequired: false
                )
            }
            
            try TimeProfiler.measure("Build patched project") {
                Logger.info("Started build project with \(targetNamesForBuild.count) targets")
                try build(
                    params: params,
                    buildDirectoryPath: buildDirectoryPath,
                    patchedProjectPath: patchedProjectPath,
                    buildLogDirectory: buildLogDirectory
                )
            }
            
            let buildedTargetInfos = targetInfoFilter.frameworkTargetInfos(targetsForBuild)
            try TimeProfiler.measure("Save artifacts from builded patched project") {
                try saveArtifacts(
                    cacheStorage: cacheStorage,
                    for: buildedTargetInfos,
                    at: cacheBuildPath,
                    dSYMShouldExist: shouldGenerateDSYMs
                )
            }
            return buildedTargetInfos
        } else {
            Logger.info("Nothing to build")
            // This is important for debugger work.
            try TimeProfiler.measure("Integrate artifacts to build directory") {
                try artifactIntegrator.integrateArtifacts(
                    checksumProducer: checksumProducer,
                    cacheStorage: cacheStorage,
                    targetInfos: targetInfosForPatchedProjectIntegration,
                    to: cacheBuildPath,
                    dSYMRequired: false
                )
            }
            return []
        }
    }
    
    private func obtainTargetsForBuild(
        cacheStorage: BuildProductCacheStorage,
        allRequiredTargetInfos: [TargetInfo<BaseChecksum>],
        requiredFramework: [TargetInfo<BaseChecksum>],
        dSYMRequired: Bool)
        throws -> [TargetInfo<BaseChecksum>]
    {
        let cachedFrameworkTargets = try obtainCachedTargets(
            targetInfos: requiredFramework,
            dSYMRequired: dSYMRequired
        )
        let frameworkTargetsForBuild = requiredFramework.filter { targetInfo in
            cachedFrameworkTargets.read(targetInfo) == nil
        }

        let connectedBundleTargets = allRequiredTargetInfos.filter { targetInfo in
            if case .bundle = targetInfo.productType {
                let connectedFrameworkTarget = frameworkTargetsForBuild.first(
                    where: { frameworkTargetInfo -> Bool in
                        frameworkTargetInfo.dependencies.contains(targetInfo.targetName)
                    }
                )
                return connectedFrameworkTarget != nil
            }
            return false
        }
        // The bundle is already in the framework (this is done by cocoapods)
        return frameworkTargetsForBuild + connectedBundleTargets
    }
    
    private func targetInfosForIntegrationToPatchedProject(
        requiredTargets: [TargetInfo<BaseChecksum>],
        targetsForBuild: [TargetInfo<BaseChecksum>])
        -> [TargetInfo<BaseChecksum>]
    {
        let targetInfos = targetInfoFilter.frameworkTargetInfos(
            requiredTargets.filter { targetInfo in
                targetsForBuild.contains(targetInfo) == false
            }
        )
        return targetInfos
    }
    
    private func patchProject(
        podsProjectPath: String,
        patchedProjectPath: String,
        targets: [String],
        shouldGenerateDSYMs: Bool,
        params: XcodeBuildEnvironmentParameters)
        throws
    {
        try patcher.patch(
            projectPath: podsProjectPath,
            outputPath: patchedProjectPath,
            targets: targets,
            shouldGenerateDSYMs: shouldGenerateDSYMs,
            params: params
        )
    }
    
    private func createTargetBuildConfig(
        params: XcodeBuildEnvironmentParameters,
        buildDirectoryPath: String,
        patchedProjectPath: String)
        throws -> XcodeProjectBuildConfig
    {
        let architectureStrings = params.architectures.split(separator: " ").map { String($0) }
        let architectures: [Architecture] = try architectureStrings.map { architectureString in
            guard let architecture = Architecture(rawValue: architectureString) else {
                throw RemoteCachePreparerError.unableToParseArchitecture(string: architectureString)
            }
            return architecture
        }
        guard let platform = Platform(rawValue: params.platformName) else {
            throw RemoteCachePreparerError.unableToParsePlatform(string: params.platformName)
        }
        let onlyActiveArchitecture = architectures.count > 1 ? false : true
        let config = XcodeProjectBuildConfig(
            platform: platform,
            architectures: architectures,
            buildDirectoryPath: buildDirectoryPath,
            projectPath: patchedProjectPath,
            targetName: "Aggregate",
            configurationName: params.configuration,
            onlyActiveArchitecture: onlyActiveArchitecture
        )
        return config
    }
    
    private func validateVersion(params: XcodeBuildEnvironmentParameters) throws {
        let commandLineVersion = try xcodeCommandLineVersionProvider.obtainXcodeCommandLineToolVersion()
        let xcodeVersion = params.xcodeProductBuildVersion
        if commandLineVersion != xcodeVersion {
            throw RemoteCachePreparerError.xcodeCommandLineVersionMismatch(
                xcodeVersion: xcodeVersion,
                commandLineVersion: commandLineVersion
            )
        }
    }
    
    private func build(
        params: XcodeBuildEnvironmentParameters,
        buildDirectoryPath: String,
        patchedProjectPath: String,
        buildLogDirectory: String?) throws
    {
        let config = try createTargetBuildConfig(
            params: params,
            buildDirectoryPath: buildDirectoryPath,
            patchedProjectPath: patchedProjectPath
        )
        // TODO: Get environment from /usr/bin/env
        try builder.build(
            config: config,
            environment: ["PATH": params.userBinaryPath],
            buildLogDirectory: buildLogDirectory
        )
    }
    
    private func saveArtifacts(
        cacheStorage: BuildProductCacheStorage,
        for targetInfos: [TargetInfo<BaseChecksum>],
        at path: String,
        dSYMShouldExist: Bool) throws
    {
        let artifacts = try artifactProvider.artifacts(
            for: targetInfos,
            at: path,
            dSYMShouldExist: dSYMShouldExist
        )
        try artifacts.asyncConcurrentEnumerate { (artifact, completion, _) in
            let frameworkCacheKey = cacheKeyBuilder.createFrameworkCacheKey(from: artifact.targetInfo)
            let dsymCacheKey = cacheKeyBuilder.createDSYMCacheKey(from: artifact.targetInfo)
            cacheStorage.add(cacheKey: frameworkCacheKey, at: artifact.productPath) {
                guard let dsymPath = artifact.dsymPath
                    else {
                        completion()
                        return
                    }
                cacheStorage.add(cacheKey: dsymCacheKey, at: dsymPath) {
                    completion()
                }
            }
        }
    }
    
    private func obtainCachedTargets(
        targetInfos: [TargetInfo<BaseChecksum>],
        dSYMRequired: Bool)
        throws -> ThreadSafeDictionary<TargetInfo<BaseChecksum>, TargetInfo<BaseChecksum>>
    {
        let cachedTargets = ThreadSafeDictionary<
            TargetInfo<BaseChecksum>, TargetInfo<BaseChecksum>
            >()
        
        try targetInfos.asyncConcurrentEnumerate { (targetInfo, completion, _) in
            let frameworkCacheKey = cacheKeyBuilder.createFrameworkCacheKey(from: targetInfo)
            let dSYMCacheKey = cacheKeyBuilder.createDSYMCacheKey(from: targetInfo)
            cacheStorage.cached(for: frameworkCacheKey) { frameworkResult in
                switch frameworkResult {
                case .result:
                    if dSYMRequired {
                        self.cacheStorage.cached(for: dSYMCacheKey) { dSYMResult in
                            switch dSYMResult {
                            case .result:
                                cachedTargets.write(targetInfo, for: targetInfo)
                            case .notExist:
                                break
                            }
                            completion()
                        }
                    } else {
                        cachedTargets.write(targetInfo, for: targetInfo)
                        completion()
                    }
                case .notExist:
                    completion()
                }
            }
        }
        return cachedTargets
    }
    
}
