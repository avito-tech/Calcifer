import Foundation
import Checksum
import Toolkit

public final class BuildParametersChecksumProducer: ChecksumProducer {
    
    public init() {}
    
    public func checksum(input: XcodeBuildEnvironmentParameters) throws -> BaseChecksum {
        let importantParams = [
            input.otherSwiftFlagsParam,
            input.gccPreprocessorDefinitionsParam,
            input.enableBitcodeParam.toStringValue(),
            input.enableTestabilityParam.toStringValue(),
            input.profilingCodeParam.toStringValue(),
            input.architecturesParam,
            input.platformNameParam,
            input.swiftVersionParam,
            input.configurationParam,
            input.sdkActualVersionParam
        ].toKeyValueDictionary()
        let paramsChecksum = try importantParams.values.sorted().map({ BaseChecksum($0) }).aggregate()
        Logger.info(
            "Build parameters checksum: \(paramsChecksum.stringValue) from \(importantParams)"
        )
        return paramsChecksum
    }
    
}
