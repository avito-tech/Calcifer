import Foundation
import XcodeBuildEnvironmentParametersParser
import XcodeProjectChecksumCalculator
import Checksum

public protocol RequiredTargetsProvider {
    func obtainRequiredTargets(
        params: XcodeBuildEnvironmentParameters,
        calciferChecksumFilePath: String,
        smartChecksumCalculate: Bool,
        validateChecksumHolder: Bool)
        throws -> [TargetInfo<BaseChecksum>]
}

public extension RequiredTargetsProvider {
    func obtainRequiredTargets(
        params: XcodeBuildEnvironmentParameters,
        calciferChecksumFilePath: String,
        validateChecksumHolder: Bool)
        throws -> [TargetInfo<BaseChecksum>]
    {
        return try obtainRequiredTargets(
            params: params,
            calciferChecksumFilePath: calciferChecksumFilePath,
            smartChecksumCalculate: true,
            validateChecksumHolder: validateChecksumHolder
        )
    }
    
    func obtainRequiredTargets(
        params: XcodeBuildEnvironmentParameters,
        calciferChecksumFilePath: String)
        throws -> [TargetInfo<BaseChecksum>]
    {
        return try obtainRequiredTargets(
            params: params,
            calciferChecksumFilePath: calciferChecksumFilePath,
            validateChecksumHolder: false
        )
    }
}
