import Foundation
import XcodeBuildEnvironmentParametersParser
import XcodeProjectChecksumCalculator
import RemoteCachePreparer
import Checksum

public final class RequiredTargetsProviderStub: RequiredTargetsProvider {
    
    public init() {}
    
    public var onObtainRequiredTargets:
        (XcodeBuildEnvironmentParameters, String) -> ([TargetInfo<BaseChecksum>]) =
        { _,_ in return [] }
    
    public func obtainRequiredTargets(
        params: XcodeBuildEnvironmentParameters,
        calciferChecksumFilePath: String)
        throws -> [TargetInfo<BaseChecksum>]
    {
        return onObtainRequiredTargets(params, calciferChecksumFilePath)
    }
    
    
}
