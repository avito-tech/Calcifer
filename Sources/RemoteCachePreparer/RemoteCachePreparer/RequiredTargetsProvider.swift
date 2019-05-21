import Foundation
import XcodeBuildEnvironmentParametersParser
import XcodeProjectChecksumCalculator
import Checksum
import Toolkit

public protocol RequiredTargetsProvider {
    func obtainRequiredTargets(
        params: XcodeBuildEnvironmentParameters,
        targetInfoFilter: TargetInfoFilter,
        buildParametersChecksum: BaseChecksum)
        throws -> [TargetInfo<BaseChecksum>]
}

public class RequiredTargetsProviderImpl: RequiredTargetsProvider {
    
    public func obtainRequiredTargets(
        params: XcodeBuildEnvironmentParameters,
        targetInfoFilter: TargetInfoFilter,
        buildParametersChecksum: BaseChecksum)
        throws -> [TargetInfo<BaseChecksum>]
    {
        let calciferPodsTargetName = "Pods-\(params.targetName)-Calcifer"
        let calciferPodsTargetInfos = try targetInfoFilter.obtainRequiredTargets(
            targetName: calciferPodsTargetName,
            buildParametersChecksum: buildParametersChecksum
        )
        if calciferPodsTargetInfos.count > 0 {
            return calciferPodsTargetInfos
        }
        let podsTargetName = "Pods-\(params.targetName)"
        let targetInfos = try targetInfoFilter.obtainRequiredTargets(
            targetName: podsTargetName,
            buildParametersChecksum: buildParametersChecksum
        )
        return targetInfos
    }
    
}
