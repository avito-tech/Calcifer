import Foundation
import XcodeBuildEnvironmentParametersParser
import XcodeProjectChecksumCalculator
import Checksum

final class TargetInfoFilter {
    
    private let targetInfoProvider: TargetInfoProvider<BaseChecksum>
    
    public init(targetInfoProvider: TargetInfoProvider<BaseChecksum>) {
        self.targetInfoProvider = targetInfoProvider
    }
    
    public func obtainRequiredTargets(
        buildParametersChecksum: BaseChecksum,
        params: XcodeBuildEnvironmentParameters)
        throws -> [TargetInfo<BaseChecksum>]
    {
        let mainTargetName = "Pods-\(params.targetName)"
        let targetInfos = try targetInfoProvider.dependencies(
            for: mainTargetName,
            buildParametersChecksum: buildParametersChecksum
        )
        return targetInfos
    }
    
    public func frameworkTargetInfos(
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
    
}
