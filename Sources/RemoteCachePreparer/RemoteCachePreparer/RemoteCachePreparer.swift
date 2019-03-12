import Foundation
import XcodeBuildEnvironmentParametersParser
import XcodeProjectChecksumCalculator
import XcodeProjectBuilder
import XcodeProjectPatcher
import BuildArtifacts
import CacheStorage
import Checksum
import Toolkit

final class RemoteCachePreparer {
    
    private let fileManager: FileManager
    
    init(fileManager: FileManager) {
        self.fileManager = fileManager
    }
    
    func prepare(params: XcodeBuildEnvironmentParameters) throws {
        let podsProjectPath = params.podsProjectPath
        let patchedProjectPath = params.patchedProjectPath
    
        let paramsChecksum = try BuildParametersChecksumProducer().checksum(input: params)
        let targetChecksumProvider = try buildTargetChecksumProvider(podsProjectPath: podsProjectPath)
        
        let requiredTargets = try obtainRequiredTargets(
            checksumProvider: targetChecksumProvider,
            buildParametersChecksum: paramsChecksum,
            params: params
        )
        
        let targetsForBuild = try obtainTargetsForBuild(
            requiredFrameworks: requiredTargets
        )
        let targetNamesForBuild = targetsForBuild.map { $0.targetName }
        
//        try patchProject(
//            podsProjectPath: podsProjectPath,
//            patchedProjectPath: patchedProjectPath,
//            targets: targetNamesForBuild
//        )
//
//        try build(
//            params: params,
//            patchedProjectPath: patchedProjectPath
//        )
        
        let buildPath = "\(params.projectDirectory)"
            .appendingPathComponent("build")
            .appendingPathComponent("\(params.configuration)-\(params.platformName)")
        let localStorage = LocalCacheStorage<BaseChecksum>(fileManager: fileManager)
        try saveArtifacts(
            localStorage: localStorage,
            for: targetsForBuild,
            at: buildPath
        )
        
        try integrateArtifacts(
            localStorage: localStorage,
            targetInfos: requiredTargets,
            to: params.configurationBuildDirectory
        )
        
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
    
    private func buildTargetChecksumProvider(podsProjectPath: String) throws -> TargetInfoProvider<BaseChecksum> {
        let checksumProducer = BaseURLChecksumProducer(fileManager: fileManager)
        let frameworkChecksumProviderFactory = TargetInfoProviderFactory(checksumProducer: checksumProducer)
        let frameworkChecksumProvider = try frameworkChecksumProviderFactory.targetChecksumProvider(
            projectPath: podsProjectPath
        )
        return frameworkChecksumProvider
    }
    
    private func obtainTargetsForBuild(
        requiredFrameworks: [TargetInfo<BaseChecksum>])
        throws -> [TargetInfo<BaseChecksum>]
    {
        // TODO: Filter the frameworks that are already in the cache.
        return requiredFrameworks
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
    
    private func build(params: XcodeBuildEnvironmentParameters, patchedProjectPath: String) throws {
        let config = try createTargetBuildConfig(
            params: params,
            patchedProjectPath: patchedProjectPath
        )
        let builder = XcodeProjectBuilder()
        builder.build(config: config)
    }
    
    private func createTargetBuildConfig(params: XcodeBuildEnvironmentParameters, patchedProjectPath: String) throws -> XcodeProjectBuildConfig {
        guard let architecture = XcodeProjectBuildConfig.Architecture(rawValue: params.architecture) else {
            throw RemoteCachePreparerError.unableToParseArchitecture(string: params.architecture)
        }
        guard let platform = XcodeProjectBuildConfig.Platform(rawValue: params.platformName) else {
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
    
    @discardableResult
    private func saveArtifacts(
        localStorage: LocalCacheStorage<BaseChecksum>,
        for targetInfos: [TargetInfo<BaseChecksum>],
        at path: String)
        throws -> [CacheValue<BaseChecksum>]
    {
        let artifactProvider = TargetBuildArtifactProvider(
            fileManager: fileManager
        )
        let artifacts = try artifactProvider.artifacts(for: targetInfos, at: path)
        
        return try artifacts.map { artifact in
            let entry = createCacheEntry(from: artifact.targetInfo)
            return try localStorage.add(entry: entry, at: artifact.path)
        }
    }
    
    private func integrateArtifacts(
        localStorage: LocalCacheStorage<BaseChecksum>,
        targetInfos: [TargetInfo<BaseChecksum>],
        to path: String) throws
    {
        let integrator = BuildArtifactIntegrator(fileManager: fileManager)
        let buildArtifacts: [TargetBuildArtifact<BaseChecksum>] = try targetInfos.map { targetInfo in
            let entry = createCacheEntry(from: targetInfo)
            guard let cacheValue = try localStorage.cache(for: entry) else {
                throw RemoteCachePreparerError.unableToObtainCache(
                    target: targetInfo.targetName,
                    checksumValue: targetInfo.checksum.description
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
    
    private func createCacheEntry(
        from targetInfo: TargetInfo<BaseChecksum>)
        -> CacheEntry<BaseChecksum>
    {
        return CacheEntry<BaseChecksum>(
            name: targetInfo.targetName,
            checksum: targetInfo.checksum
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
