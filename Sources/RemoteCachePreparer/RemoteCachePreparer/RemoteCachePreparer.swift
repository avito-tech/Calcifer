import Foundation
import XcodeBuildEnvironmentParametersParser
import XcodeProjectChecksumCalculator
import XcodeProjectBuilder
import XcodeProjectPatcher
import BuildArtifacts
import ShellCommand
import BuildProductCacheStorage
import DSYMSymbolizer
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
        let integrated = try TimeProfiler.measure("Integrate artifacts to Derived Data") {
            try integrateArtifacts(
                checksumProducer: checksumProducer,
                cacheStorage: cacheStorage,
                targetInfos: targetInfosForIntegration,
                to: params.configurationBuildDirectory
            )
        }
        
        try TimeProfiler.measure("Patch dSYM") {
            let sourceRoot = params.podsRoot
                .deletingLastPathComponent()
                .deletingLastPathComponent()
            try patchDSYM(for: integrated, sourceRoot: sourceRoot)
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
        // If we do not need to store an artifact, then we don’t need to build it.
        // The bundle targates are filtered out because they are already inside some framework (cocoapods does this)
        // If any file in the bundle has changed, then all dependencies will be rebuilded.
        // Because their checksum has changed.
        if targetNamesForBuild.count > 0 {
        
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
                    for: frameworkTargetInfos(targetsForBuild),
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
        let allTargetForBuild = try requiredFrameworks.filter { targetInfo in
            let frameworkCacheKey = createFrameworkCacheKey(from: targetInfo)
            let dSYMCacheKey = createDSYMCacheKey(from: targetInfo)
            let frameworkCacheValue = try cacheStorage.cached(for: frameworkCacheKey)
            let dSYMCacheKeyCacheValue = try cacheStorage.cached(for: dSYMCacheKey)
            return frameworkCacheValue == nil || dSYMCacheKeyCacheValue == nil
        }
        let frameworkTargets = allTargetForBuild.filter { targetInfo in
            if case .bundle = targetInfo.productType {
                return false
            }
            return true
        }
        let connectedBundleTargets = allTargetForBuild.filter { targetInfo in
            if case .bundle = targetInfo.productType {
                let connectedFrameworkTarget = frameworkTargets.first(
                    where: { frameworkTargetInfo -> Bool in
                        frameworkTargetInfo.dependencies.contains(targetInfo.targetName)
                    }
                )
                return connectedFrameworkTarget != nil
            }
            return false
        }
        // The bundle is already in the framework (this is done by cocoapods)
        return frameworkTargets + connectedBundleTargets
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
            let frameworkCacheKey = createFrameworkCacheKey(from: artifact.targetInfo)
            try cacheStorage.add(cacheKey: frameworkCacheKey, at: artifact.productPath)
            
            let dsymCacheKey = createDSYMCacheKey(from: artifact.targetInfo)
            try cacheStorage.add(cacheKey: dsymCacheKey, at: artifact.dsymPath)
        }
    }
    
    @discardableResult
    private func integrateArtifacts(
        checksumProducer: BaseURLChecksumProducer,
        cacheStorage: DefaultMixedFrameworkCacheStorage,
        targetInfos: [TargetInfo<BaseChecksum>],
        to path: String) throws -> [TargetBuildArtifact<BaseChecksum>]
    {
        let integrator = BuildArtifactIntegrator(
            fileManager: fileManager,
            checksumProducer: checksumProducer
        )
        let artifacts: [TargetBuildArtifact<BaseChecksum>] = try targetInfos.map { targetInfo in
            
            let frameworkCacheKey = createFrameworkCacheKey(from: targetInfo)
            guard let frameworkCacheValue = try cacheStorage.cached(for: frameworkCacheKey) else {
                throw RemoteCachePreparerError.unableToObtainCache(
                    target: targetInfo.targetName,
                    type: targetInfo.productType.rawValue,
                    checksumValue: targetInfo.checksum.stringValue
                )
            }
            
            let dSYMCacheKey = createDSYMCacheKey(from: targetInfo)
            guard let dSYMCacheValue = try cacheStorage.cached(for: dSYMCacheKey) else {
                throw RemoteCachePreparerError.unableToObtainCache(
                    target: targetInfo.targetName,
                    type: targetInfo.productType.rawValue,
                    checksumValue: targetInfo.checksum.stringValue
                )
            }
            
            let artifact = TargetBuildArtifact(
                targetInfo: targetInfo,
                productPath: frameworkCacheValue.path,
                dsymPath: dSYMCacheValue.path
            )
            return artifact
        }
        let destionations = try integrator.integrate(artifacts: artifacts, to: path)
        return destionations
    }
    
    private func createFrameworkCacheKey(
        from targetInfo: TargetInfo<BaseChecksum>)
        -> BuildProductCacheKey<BaseChecksum>
    {
        return BuildProductCacheKey<BaseChecksum>(
            productName: targetInfo.targetName,
            productType: .framework,
            checksum: targetInfo.checksum
        )
    }
    
    private func createDSYMCacheKey(
        from targetInfo: TargetInfo<BaseChecksum>)
        -> BuildProductCacheKey<BaseChecksum>
    {
        return BuildProductCacheKey<BaseChecksum>(
            productName: targetInfo.targetName,
            productType: .dSYM,
            checksum: targetInfo.checksum
        )
    }
    
    private func frameworkTargetInfos(
        _ targetInfos: [TargetInfo<BaseChecksum>])
        -> [TargetInfo<BaseChecksum>]
    {
        return targetInfos.filter { targetInfo in
            if case .bundle = targetInfo.productType {
                return false
            }
            return true
        }
    }
    
    private func createDSYMSymbolizer() -> DSYMSymbolizer {
        let shellCommandExecutor = ShellCommandExecutorImpl()
        let symbolizer = DSYMSymbolizer(
            symbolTableProvider: SymbolTableProviderImpl(shellCommandExecutor: shellCommandExecutor),
            dwarfUUIDProvider: DWARFUUIDProviderImpl(shellCommandExecutor: shellCommandExecutor),
            fileManager: fileManager
        )
        return symbolizer
    }
    
    private func patchDSYM(
        for artifacts: [TargetBuildArtifact<BaseChecksum>],
        sourceRoot: String) throws
    {
        let symbolizer = createDSYMSymbolizer()
        for artifact in artifacts {
            let dsymPath = artifact.dsymPath
            let binaryPath = try obtainBinaryPath(
                from: artifact.productPath,
                targetInfo: artifact.targetInfo
            )
            try symbolizer.symbolize(
                dsymPath: dsymPath,
                sourcePath: sourceRoot,
                binaryPath: binaryPath
            )
        }
    }
    
    private func obtainBinaryPath(
        from productPath: String,
        targetInfo: TargetInfo<BaseChecksum>)
        throws -> String
    {
        var path = productPath
            .appendingPathComponent(targetInfo.productName.deletingPathExtension())
        if fileManager.fileExists(atPath: path) {
            return path
        }
        path = productPath
            .appendingPathComponent(productPath.lastPathComponent().deletingPathExtension())
        if fileManager.fileExists(atPath: path) {
            return path
        }
        path = productPath.appendingPathComponent(targetInfo.targetName)
        if fileManager.fileExists(atPath: path) {
            return path
        }
        throw RemoteCachePreparerError.unableToBinaryInFramework(
            path: path,
            productName: targetInfo.productName
        )
    }
    
    typealias DefaultMixedFrameworkCacheStorage = MixedBuildProductCacheStorage<
        BaseChecksum,
        LocalBuildProductCacheStorage<BaseChecksum>,
        GradleRemoteBuildProductCacheStorage<BaseChecksum>>
    
    private func createCacheStorage() throws -> DefaultMixedFrameworkCacheStorage {
        let localCacheDirectoryPath = fileManager.calciferDirectory()
            .appendingPathComponent("localCache")
        let localStorage = LocalBuildProductCacheStorage<BaseChecksum>(
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
        let remoteStorage = GradleRemoteBuildProductCacheStorage<BaseChecksum>(
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
