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
    
    public init() {}
    
    public func obtainRequiredTargets(
        params: XcodeBuildEnvironmentParameters,
        targetInfoFilter: TargetInfoFilter,
        buildParametersChecksum: BaseChecksum)
        throws -> [TargetInfo<BaseChecksum>]
    {
        let calciferPodsTargetName = "Pods-\(params.targetName)-Calcifer"
        guard let calciferPodsTargetInfos = try? targetInfoFilter.obtainRequiredTargets(
            targetName: calciferPodsTargetName,
            buildParametersChecksum: buildParametersChecksum)
            else {
                let podsTargetName = "Pods-\(params.targetName)"
                guard let podsTargetInfos = try? targetInfoFilter.obtainRequiredTargets(
                    targetName: podsTargetName,
                    buildParametersChecksum: buildParametersChecksum)
                    else {
                        let calciferTargetName = "\(params.targetName)-Calcifer"
                        let targetInfos = try targetInfoFilter.obtainRequiredTargets(
                            targetName: calciferTargetName,
                            buildParametersChecksum: buildParametersChecksum
                        )
                        return targetInfos
                    }
                return podsTargetInfos
            }
        return calciferPodsTargetInfos
    }
    
}
