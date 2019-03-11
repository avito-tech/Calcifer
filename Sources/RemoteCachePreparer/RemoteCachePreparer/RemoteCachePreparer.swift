import Foundation
import XcodeBuildEnvironmentParametersParser
import XcodeProjectChecksumCalculator
import XcodeProjectBuilder
import XcodeProjectPatcher
import Checksum
import Toolkit

final class RemoteCachePreparer {
    
    init() {}
    
    func prepare() throws {
        
        let params = try XcodeBuildEnvironmentParameters()
    
        let podsProjectPath = params.podsProjectPath
        let patchedProjectPath = params.patchedProjectPath
    
        let paramsChecksum = try BuildParametersChecksumProducer().checksum(input: params)
        let targetChecksumProvider = try buildTargetChecksumProvider(podsProjectPath: podsProjectPath)
        
        let requiredTargets = try obtainRequiredTargets(
            checksumProvider: targetChecksumProvider,
            params: params
        )
        
        let targetsForBuild = try obtainTargetsForBuild(
            requiredFrameworks: requiredTargets,
            paramsChecksum: paramsChecksum,
            targetChecksumProvider: targetChecksumProvider
        )
        
        try patchProject(
            podsProjectPath: podsProjectPath,
            patchedProjectPath: patchedProjectPath,
            targets: targetsForBuild
        )
        
        try build(
            params: params,
            patchedProjectPath: patchedProjectPath
        )
    }
    
    private func obtainRequiredTargets(
        checksumProvider: TargetChecksumProvider<BaseChecksum>,
        params: XcodeBuildEnvironmentParameters)
        throws -> [String]
    {
        let mainTargetName = "Pods-\(params.targetName)"
        let frameworks = try checksumProvider.dependencies(
            for: mainTargetName
        )
        return frameworks
    }
    
    private func buildTargetChecksumProvider(podsProjectPath: String) throws -> TargetChecksumProvider<BaseChecksum> {
        let checksumProducer = BaseURLChecksumProducer(fileManager: FileManager.default)
        let frameworkChecksumProviderFactory = TargetChecksumProviderFactory(checksumProducer: checksumProducer)
        let frameworkChecksumProvider = try frameworkChecksumProviderFactory.targetChecksumProvider(
            projectPath: podsProjectPath
        )
        return frameworkChecksumProvider
    }
    
    private func obtainTargetsForBuild(
        requiredFrameworks: [String],
        paramsChecksum: BaseChecksum,
        targetChecksumProvider: TargetChecksumProvider<BaseChecksum>)
        throws -> [String]
    {
        let checksums = Dictionary(
            uniqueKeysWithValues:
            try requiredFrameworks.map({ frameworkName -> ((String), BaseChecksum) in
                let checksum = try targetChecksumProvider.checksum(
                    for: frameworkName,
                    buildParametersChecksum: paramsChecksum
                )
                return (frameworkName, checksum)
            })
        )
        // TODO: Filter the frameworks that are already in the cache.
        return Array(checksums.keys)
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
            throw BuildRunnerError.unableToParseArchitecture(string: params.architecture)
        }
        guard let platform = XcodeProjectBuildConfig.Platform(rawValue: params.platformName) else {
            throw BuildRunnerError.unableToParsePlatform(string: params.platformName)
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
