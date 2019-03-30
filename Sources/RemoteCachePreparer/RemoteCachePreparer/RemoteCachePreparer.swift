import Foundation
import XcodeBuildEnvironmentParametersParser
import XcodeProjectChecksumCalculator
import XcodeProjectBuilder
import XcodeProjectPatcher
import BuildArtifacts
import FrameworkCacheStorage
import Checksum
import Toolkit

final class RemoteCachePreparer {
    
    private let fileManager: FileManager
    
    init(fileManager: FileManager) {
        self.fileManager = fileManager
    }
    
    func prepare(params: XcodeBuildEnvironmentParameters) throws {
        let podsProjectPath = params.podsProjectPath
        
        let checksumProducer = BaseURLChecksumProducer(fileManager: fileManager)
        let paramsChecksum = try BuildParametersChecksumProducer().checksum(input: params)
        
        // TODO: save xcodeproj as json and if hash of xml same use json instead xcodeproj
        let targetChecksumProvider = try TimeProfiler.measure("Calculate checksum") {
            try buildTargetChecksumProvider(
                podsProjectPath: podsProjectPath,
                checksumProducer: checksumProducer
            )
        }
        
        let cacheStorage = try TimeProfiler.measure("Create cache storage") {
            try createCacheStorage()
        }
        
        let requiredTargets = try TimeProfiler.measure("Obtain required targets") {
            try obtainRequiredTargets(
                checksumProvider: targetChecksumProvider,
                buildParametersChecksum: paramsChecksum,
                params: params
            )
        }

        try TimeProfiler.measure("Prepare and build patched project if needed") {
            try prepareAndBuildPatchedProjectIfNeeded(
                params: params,
                requiredTargets: requiredTargets,
                cacheStorage: cacheStorage,
                checksumProducer: checksumProducer
            )
        }
        
        let targetInfosForIntegration = frameworkTargetInfos(requiredTargets)
        try TimeProfiler.measure("Integrate artifacts to Derived Data") {
            try integrateArtifacts(
                checksumProducer: checksumProducer,
                cacheStorage: cacheStorage,
                targetInfos: targetInfosForIntegration,
                to: params.configurationBuildDirectory
            )
        }
        
    }
    
    private func obtainRequiredTargets(
        checksumProvider: TargetInfoProvider<BaseChecksum>,
        buildParametersChecksum: BaseChecksum,
        params: XcodeBuildEnvironmentParameters)
        throws -> [TargetInfo<BaseChecksum>]
    {
        let mainTargetName = "Pods-\(params.targetName)"
        let targetInfos = try checksumProvider.dependencies(
            for: mainTargetName,
            buildParametersChecksum: buildParametersChecksum
        )
        return targetInfos
    }
    
    private func prepareAndBuildPatchedProjectIfNeeded(
        params: XcodeBuildEnvironmentParameters,
        requiredTargets: [TargetInfo<BaseChecksum>],
        cacheStorage: DefaultMixedFrameworkCacheStorage,
        checksumProducer: BaseURLChecksumProducer)
        throws
    {
    
        let podsProjectPath = params.podsProjectPath
        let patchedProjectPath = params.patchedProjectPath
        
        let targetsForBuild = try obtainTargetsForBuild(
            cacheStorage: cacheStorage,
            requiredFrameworks: requiredTargets
        )
        let targetNamesForBuild = targetsForBuild.map { $0.targetName }
        let targetInfosForStore = frameworkTargetInfos(targetsForBuild)
        
        // If we do not need to store an artifact, then we don’t need to build it.
        // The bundle targates are filtered out because they are already inside some framework (cocoapods does this)
        // If any file in the bundle has changed, then all dependencies will be rebuilded.
        // Because their checksum has changed.
        if targetInfosForStore.count > 0 {
        
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
                try integrateArtifacts(
                    checksumProducer: checksumProducer,
                    cacheStorage: cacheStorage,
                    targetInfos: targetInfosForPatchedProjectIntegration,
                    to: cacheBuildPath
                )
            }
            
            try TimeProfiler.measure("Build patched project") {
                try build(
                    params: params,
                    patchedProjectPath: patchedProjectPath
                )
            }
            
            try TimeProfiler.measure("Save artifacts from builded patched project") {
                try saveArtifacts(
                    cacheStorage: cacheStorage,
                    for: targetInfosForStore,
                    at: cacheBuildPath
                )
            }
        }
    }
    
    private func targetInfosForIntegrationToPatchedProject(
        requiredTargets: [TargetInfo<BaseChecksum>],
        targetsForBuild: [TargetInfo<BaseChecksum>])
        -> [TargetInfo<BaseChecksum>]
    {
        let targetInfos = frameworkTargetInfos(
            requiredTargets.filter { targetInfo in
                targetsForBuild.contains(targetInfo) == false
            }
        )
        return targetInfos
    }
    
    private func buildTargetChecksumProvider(
        podsProjectPath: String,
        checksumProducer: BaseURLChecksumProducer)
        throws -> TargetInfoProvider<BaseChecksum>
    {
        let frameworkChecksumProviderFactory = TargetInfoProviderFactory(
            checksumProducer: checksumProducer
        )
        let frameworkChecksumProvider = try frameworkChecksumProviderFactory.targetChecksumProvider(
            projectPath: podsProjectPath
        )
        return frameworkChecksumProvider
    }
    
    private func obtainTargetsForBuild(
        cacheStorage: DefaultMixedFrameworkCacheStorage,
        requiredFrameworks: [TargetInfo<BaseChecksum>])
        throws -> [TargetInfo<BaseChecksum>]
    {
        return try requiredFrameworks.filter { targetInfo in
            let cacheKey = createCacheKey(from: targetInfo)
            let cacheValue = try cacheStorage.cached(for: cacheKey)
            return cacheValue == nil
        }
    }
    
    private func patchProject(
        podsProjectPath: String,
        patchedProjectPath: String,
        targets: [String]) throws
    {
        let patcher = XcodeProjectPatcher()
        try patcher.patch(
            projectPath: podsProjectPath,
            outputPath: patchedProjectPath,
            targets: targets
        )
    }
    
    private func build(
        params: XcodeBuildEnvironmentParameters,
        patchedProjectPath: String) throws
    {
        let config = try createTargetBuildConfig(
            params: params,
            patchedProjectPath: patchedProjectPath
        )
        let builder = XcodeProjectBuilder(
            shellExecutor: ShellCommandExecutorImpl()
        )
        // TODO: Get environment from /usr/bin/env
        try builder.build(
            config: config,
            environment: ["PATH": params.userBinaryPath]
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
    
    private func saveArtifacts(
        cacheStorage: DefaultMixedFrameworkCacheStorage,
        for targetInfos: [TargetInfo<BaseChecksum>],
        at path: String) throws
    {
        let artifactProvider = TargetBuildArtifactProvider(
            fileManager: fileManager
        )
        let artifacts = try artifactProvider.artifacts(for: targetInfos, at: path)
        
        try artifacts.forEach { artifact in
            let cacheKey = createCacheKey(from: artifact.targetInfo)
            try cacheStorage.add(cacheKey: cacheKey, at: artifact.path)
        }
    }
    
    private func integrateArtifacts(
        checksumProducer: BaseURLChecksumProducer,
        cacheStorage: DefaultMixedFrameworkCacheStorage,
        targetInfos: [TargetInfo<BaseChecksum>],
        to path: String) throws
    {
        let integrator = BuildArtifactIntegrator(
            fileManager: fileManager,
            checksumProducer: checksumProducer
        )
        let buildArtifacts: [TargetBuildArtifact<BaseChecksum>] = try targetInfos.map { targetInfo in
            let cacheKey = createCacheKey(from: targetInfo)
            guard let cacheValue = try cacheStorage.cached(for: cacheKey) else {
                throw RemoteCachePreparerError.unableToObtainCache(
                    target: targetInfo.targetName,
                    checksumValue: targetInfo.checksum.stringValue
                )
            }
            let buildArtifact = TargetBuildArtifact(
                targetInfo: targetInfo,
                path: cacheValue.path
            )
            return buildArtifact
        }
        try integrator.integrate(artifacts: buildArtifacts, to: path)
    }
    
    private func createCacheKey(
        from targetInfo: TargetInfo<BaseChecksum>)
        -> FrameworkCacheKey<BaseChecksum>
    {
        return FrameworkCacheKey<BaseChecksum>(
            frameworkName: targetInfo.targetName,
            checksum: targetInfo.checksum
        )
    }
    
    private func frameworkTargetInfos(
        _ targetInfos: [TargetInfo<BaseChecksum>])
        -> [TargetInfo<BaseChecksum>]
    {
        // The bundle is already in the framework (this is done by cocoapods)
        return targetInfos.filter { targetInfo in
            if case .bundle = targetInfo.productType {
                return false
            }
            return true
        }
    }
    
    typealias DefaultMixedFrameworkCacheStorage = MixedFrameworkCacheStorage<
        BaseChecksum,
        LocalFrameworkCacheStorage<BaseChecksum>,
        GradleRemoteFrameworkCacheStorage<BaseChecksum>>
    
    private func createCacheStorage() throws -> DefaultMixedFrameworkCacheStorage {
        let localCacheDirectoryPath = fileManager.calciferDirectory()
            .appendingPathComponent("localCache")
        let localStorage = LocalFrameworkCacheStorage<BaseChecksum>(
            fileManager: fileManager,
            cacheDirectoryPath: localCacheDirectoryPath
        )
        let gradleHost = "http://gradle-remote-cache-ios.k.avito.ru"
        guard let gradleHostURL = URL(string: gradleHost) else {
            throw RemoteCachePreparerError.unableToCreateRemoteCacheHostURL(
                string: gradleHost
            )
        }
        let gradleClient = GradleBuildCacheClientImpl(
            gradleHost: gradleHostURL,
            session: URLSession.shared
        )
        let remoteStorage = GradleRemoteFrameworkCacheStorage<BaseChecksum>(
            gradleBuildCacheClient: gradleClient,
            fileManager: fileManager
        )
        return DefaultMixedFrameworkCacheStorage(
            fileManager: fileManager,
            localCacheStorage: localStorage,
            remoteCacheStorage: remoteStorage,
            shouldUpload: true
        )
    }
    
}

extension XcodeBuildEnvironmentParameters {
    
    var podsProjectPath: String {
        let podsProjectFileName = "Pods.xcodeproj"
        let podsProjectPath = podsRoot + "/" + podsProjectFileName
        return podsProjectPath
    }
    
    var patchedProjectPath: String {
        let patchedProjectFileName = "Pods2.xcodeproj"
        let patchedProjectPath = podsRoot + "/" + patchedProjectFileName
        return patchedProjectPath
    }
    
}
