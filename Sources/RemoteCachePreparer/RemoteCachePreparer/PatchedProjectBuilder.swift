import Foundation
import XcodeBuildEnvironmentParametersParser
import XcodeProjectChecksumCalculator
import BuildProductCacheStorage
import XcodeProjectBuilder
import XcodeProjectPatcher
import BuildArtifacts
import ShellCommand
import Checksum
import Toolkit

final class PatchedProjectBuilder {
    
    private let cacheStorage: DefaultMixedFrameworkCacheStorage
    private let checksumProducer: BaseURLChecksumProducer
    private let cacheKeyBuilder: BuildProductCacheKeyBuilder
    private let patcher: XcodeProjectPatcher
    private let builder: XcodeProjectBuilder
    private let artifactIntegrator: ArtifactIntegrator
    private let targetInfoFilter: TargetInfoFilter
    private let artifactProvider: TargetBuildArtifactProvider
    
    init(
        cacheStorage: DefaultMixedFrameworkCacheStorage,
        checksumProducer: BaseURLChecksumProducer,
        cacheKeyBuilder: BuildProductCacheKeyBuilder,
        patcher: XcodeProjectPatcher,
        builder: XcodeProjectBuilder,
        artifactIntegrator: ArtifactIntegrator,
        targetInfoFilter: TargetInfoFilter,
        artifactProvider: TargetBuildArtifactProvider)
    {
        self.cacheStorage = cacheStorage
        self.checksumProducer = checksumProducer
        self.cacheKeyBuilder = cacheKeyBuilder
        self.patcher = patcher
        self.builder = builder
        self.artifactIntegrator = artifactIntegrator
        self.targetInfoFilter = targetInfoFilter
        self.artifactProvider = artifactProvider
    }
    
    public func prepareAndBuildPatchedProjectIfNeeded(
        params: XcodeBuildEnvironmentParameters,
        requiredTargets: [TargetInfo<BaseChecksum>])
        throws
    {
        
        let podsProjectPath = params.podsProjectPath
        let patchedProjectPath = params.patchedProjectPath
        
        let targetsForBuild = try TimeProfiler.measure("Obtain targets for build") {
            try obtainTargetsForBuild(
                cacheStorage: cacheStorage,
                requiredFrameworks: requiredTargets
            )
        }
        let targetNamesForBuild = targetsForBuild.map { $0.targetName }
        // If we do not need to store an artifact, then we don’t need to build it.
        // The bundle targets are filtered out because they are already inside some framework (cocoapods does this)
        // If any file in the bundle has changed, then all dependencies will be rebuilt.
        // Because their checksum has changed.
        if targetNamesForBuild.count > 0 {
            Logger.verbose("Target for build: \(targetNamesForBuild)")
            try TimeProfiler.measure("patch project") {
                try patchProject(
                    podsProjectPath: podsProjectPath,
                    patchedProjectPath: patchedProjectPath,
                    targets: targetNamesForBuild
                )
            }
            
            let cacheBuildPath = params.projectDirectory
                .appendingPathComponent("build")
                .appendingPathComponent("\(params.configuration)-\(params.platformName)")
            
            let targetInfosForPatchedProjectIntegration = targetInfosForIntegrationToPatchedProject(
                requiredTargets: requiredTargets,
                targetsForBuild: targetsForBuild
            )
            
            try TimeProfiler.measure("Integrate artifacts to patched project") {
                try artifactIntegrator.integrateArtifacts(
                    checksumProducer: checksumProducer,
                    cacheStorage: cacheStorage,
                    targetInfos: targetInfosForPatchedProjectIntegration,
                    to: cacheBuildPath
                )
            }
            
            try TimeProfiler.measure("Build patched project") {
                Logger.info("Started build project with \(targetNamesForBuild.count) targets")
                try build(
                    params: params,
                    patchedProjectPath: patchedProjectPath
                )
            }
            
            try TimeProfiler.measure("Save artifacts from builded patched project") {
                try saveArtifacts(
                    cacheStorage: cacheStorage,
                    for: targetInfoFilter.frameworkTargetInfos(targetsForBuild),
                    at: cacheBuildPath
                )
            }
        } else {
            Logger.info("Nothing to build")
        }
    }
    
    
    private func obtainTargetsForBuild(
        cacheStorage: DefaultMixedFrameworkCacheStorage,
        requiredFrameworks: [TargetInfo<BaseChecksum>])
        throws -> [TargetInfo<BaseChecksum>]
    {
        let frameworkTargets = targetInfoFilter.frameworkTargetInfos(requiredFrameworks)
        let cachedFrameworkTargets = obtainCachedTargets(targetInfos: frameworkTargets)
        let frameworkTargetsForBuild = frameworkTargets.filter { targetInfo in
            cachedFrameworkTargets.read(targetInfo) == nil
        }

        let connectedBundleTargets = requiredFrameworks.filter { targetInfo in
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
        targets: [String]) throws
    {
        try patcher.patch(
            projectPath: podsProjectPath,
            outputPath: patchedProjectPath,
            targets: targets
        )
    }
    
    private func createTargetBuildConfig(
        params: XcodeBuildEnvironmentParameters,
        patchedProjectPath: String)
        throws -> XcodeProjectBuildConfig
    {
        guard let architecture = Architecture(rawValue: params.architectures) else {
            throw RemoteCachePreparerError.unableToParseArchitecture(string: params.architectures)
        }
        guard let platform = Platform(rawValue: params.platformName) else {
            throw RemoteCachePreparerError.unableToParsePlatform(string: params.platformName)
        }
        let config = XcodeProjectBuildConfig(
            platform: platform,
            architecture: architecture,
            projectPath: patchedProjectPath,
            targetName: "Aggregate",
            configurationName: params.configuration,
            onlyActiveArchitecture: true
        )
        return config
    }
    
    private func build(
        params: XcodeBuildEnvironmentParameters,
        patchedProjectPath: String) throws
    {
        let config = try createTargetBuildConfig(
            params: params,
            patchedProjectPath: patchedProjectPath
        )
        // TODO: Get environment from /usr/bin/env
        try builder.build(
            config: config,
            environment: ["PATH": params.userBinaryPath]
        )
    }
    
    private func saveArtifacts(
        cacheStorage: DefaultMixedFrameworkCacheStorage,
        for targetInfos: [TargetInfo<BaseChecksum>],
        at path: String) throws
    {
        let artifacts = try artifactProvider.artifacts(for: targetInfos, at: path)
        let dispatchGroup = DispatchGroup()
        let array = NSArray(array: artifacts)
        array.enumerateObjects(options: .concurrent) { obj, key, stop in
            guard let artifact = obj as? TargetBuildArtifact<BaseChecksum> else {
                return
            }
            let frameworkCacheKey = cacheKeyBuilder.createFrameworkCacheKey(from: artifact.targetInfo)
            let dsymCacheKey = cacheKeyBuilder.createDSYMCacheKey(from: artifact.targetInfo)
            dispatchGroup.enter()
            cacheStorage.add(cacheKey: frameworkCacheKey, at: artifact.productPath) {
                cacheStorage.add(cacheKey: dsymCacheKey, at: artifact.dsymPath) {
                    dispatchGroup.leave()
                }
            }
        }
        dispatchGroup.wait()
    }
    
    private func obtainCachedTargets(
        targetInfos: [TargetInfo<BaseChecksum>])
        -> ThreadSafeDictionary<TargetInfo<BaseChecksum>, TargetInfo<BaseChecksum>>
    {
        let cachedTargets = ThreadSafeDictionary<
            TargetInfo<BaseChecksum>, TargetInfo<BaseChecksum>
            >()
        let dispatchGroup = DispatchGroup()
        let array = NSArray(array: targetInfos)
        array.enumerateObjects(options: .concurrent) { obj, key, stop in
            dispatchGroup.enter()
            guard let targetInfo = obj as? TargetInfo<BaseChecksum> else {
                dispatchGroup.leave()
                return
            }
            let frameworkCacheKey = cacheKeyBuilder.createFrameworkCacheKey(from: targetInfo)
            let dSYMCacheKey = cacheKeyBuilder.createDSYMCacheKey(from: targetInfo)
            cacheStorage.cached(for: frameworkCacheKey) { frameworkResult in
                switch frameworkResult {
                case .result:
                    self.cacheStorage.cached(for: dSYMCacheKey) { dSYMResult in
                        switch dSYMResult {
                        case .result:
                            cachedTargets.write(targetInfo, for: targetInfo)
                        case .notExist:
                            break
                        }
                        dispatchGroup.leave()
                    }
                case .notExist:
                    dispatchGroup.leave()
                }
            }
        }
        dispatchGroup.wait()
        return cachedTargets
    }
}
