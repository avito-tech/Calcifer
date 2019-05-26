import Foundation
import Checksum
import Toolkit

public final class BuildParametersChecksumProducer: ChecksumProducer {
    
    public init() {}
    
    public func checksum(input: XcodeBuildEnvironmentParameters) throws -> BaseChecksum {
        let importantParams = [
            input.otherSwiftFlags,
            input.gccPreprocessorDefinitions,
            String(input.enableBitcode),
            String(input.enableTestability),
            String(input.profilingCode),
            input.currentArchitecture,
            input.architectures,
            input.platformName,
            input.swiftVersion,
            input.configuration,
        ]
        let paramsChecksum = try importantParams.map({ BaseChecksum($0) }).aggregate()
        Logger.info(
            "Build parameters checksum: \(paramsChecksum.stringValue) from \(importantParams)"
        )
        return paramsChecksum
    }
    
}
