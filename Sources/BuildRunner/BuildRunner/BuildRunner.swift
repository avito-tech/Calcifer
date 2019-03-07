import Foundation
import ProjectChecksumCalculator
import BuildParametersParser
import FrameworkBuilder
import ProjectPatcher
import Checksum
import Toolkit

final class BuildRunner {
    
    init() {}
    
    func run() throws {
        
        let params = try BuildParameters()
    
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
        params: BuildParameters)
        throws -> [String]
    {
        let mainTargetName = "Pods-\(params.targetName)"
        let frameworks = try checksumProvider.dependencies(
            for: mainTargetName
        )
        return frameworks
    }
    
    private func buildTargetChecksumProvider(podsProjectPath: String) throws -> TargetChecksumProvider<BaseChecksum> {
        let checksumProducer = BaseURLChecksumProducer()
        let frameworkChecksumProviderFactory = FrameworkChecksumProviderFactory(checksumProducer: checksumProducer)
        let frameworkChecksumProvider = try frameworkChecksumProviderFactory.frameworkChecksumProvider(
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
        let patcher = ProjectPatcher()
        try patcher.patch(
            projectPath: podsProjectPath,
            outputPath: patchedProjectPath,
            targets: targets
        )
    }
    
    private func build(params: BuildParameters, patchedProjectPath: String) throws {
        let config = createTargetBuildConfig(
            params: params,
            patchedProjectPath: patchedProjectPath
        )
        let builder = FrameworkBuilder()
        builder.build(config: config)
    }
    
    private func createTargetBuildConfig(params: BuildParameters, patchedProjectPath: String) throws -> TargetBuildConfig {
        guard let architecture = TargetBuildConfig.Architecture(rawValue: params.architecture) else {
            throw BuildRunnerError.unableParseArchitecture(string: params.architecture)
        }
        guard let platform = TargetBuildConfig.Platform(rawValue: params.platformName) else {
            throw BuildRunnerError.unableParsePlatform(string: params.platformName)
        }
        let config = TargetBuildConfig(
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

extension BuildParameters {
    
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
