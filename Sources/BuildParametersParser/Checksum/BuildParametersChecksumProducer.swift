import Foundation
import Checksum

public final class BuildParametersChecksumProducer: ChecksumProducer {
    
    public init() {}
    
    public func checksum(input: BuildParameters) throws -> BaseChecksum {
        let importantParams = [
            input.otherSwiftFlags,
            input.gccPreprocessorDefinitions,
            String(input.enableBitcode),
            String(input.enableTestability),
            input.currentArchitecture,
            input.platformName,
            input.swiftVersion,
            input.configuration,
        ]
        return try importantParams.map({ BaseChecksum($0) }).aggregate()
    }
    
}
