import Foundation
import XcodeBuildEnvironmentParametersParser
import XcodeProjectChecksumCalculator
import Checksum
import Toolkit

public class RequiredTargetsProviderImpl: RequiredTargetsProvider {
    
    private let targetInfoProviderFactory: TargetInfoProviderFactory
    private let targetInfoFilter: TargetInfoFilter
    
    public init(
        targetInfoProviderFactory: TargetInfoProviderFactory,
        targetInfoFilter: TargetInfoFilter)
    {
        self.targetInfoProviderFactory = targetInfoProviderFactory
        self.targetInfoFilter = targetInfoFilter
    }
    
    public func obtainRequiredTargets(
        params: XcodeBuildEnvironmentParameters,
        calciferChecksumFilePath: String,
        validateChecksumHolder: Bool)
        throws -> [TargetInfo<BaseChecksum>]
    {
        
        let buildParametersChecksum = try BuildParametersChecksumProducer().checksum(input: params)
        let projectPath = params.podsProjectPath
        let calciferPodsTargetName = "Pods-\(params.targetName)-Calcifer"
        let targetInfoProvider = try createTargetInfoProvider(
            projectPath: projectPath,
            calciferChecksumFilePath: calciferChecksumFilePath,
            validateChecksumHolder: validateChecksumHolder
        )
        
        guard let calciferPodsTargetInfos = try? targetInfoFilter.obtainRequiredTargets(
            targetName: calciferPodsTargetName,
            targetInfoProvider: targetInfoProvider,
            buildParametersChecksum: buildParametersChecksum)
            else {
                let podsTargetName = "Pods-\(params.targetName)"
                guard let podsTargetInfos = try? targetInfoFilter.obtainRequiredTargets(
                    targetName: podsTargetName,
                    targetInfoProvider: targetInfoProvider,
                    buildParametersChecksum: buildParametersChecksum)
                    else {
                        let calciferTargetName = "\(params.targetName)-Calcifer"
                        let targetInfos = try targetInfoFilter.obtainRequiredTargets(
                            targetName: calciferTargetName,
                            targetInfoProvider: targetInfoProvider,
                            buildParametersChecksum: buildParametersChecksum
                        )
                        return targetInfos
                    }
                return podsTargetInfos
            }
        return calciferPodsTargetInfos
    }
    
    private func createTargetInfoProvider(
        projectPath: String,
        calciferChecksumFilePath: String,
        validateChecksumHolder: Bool)
        throws -> TargetInfoProvider<BaseChecksum>
    {
        let targetInfoProvider = try targetInfoProviderFactory.targetChecksumProvider(
            projectPath: projectPath,
            validateChecksumHolder: validateChecksumHolder
        )
        targetInfoProvider.saveChecksum(
            to: calciferChecksumFilePath
        )
        return targetInfoProvider
    }
    
}
