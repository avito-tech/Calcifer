import XcodeBuildEnvironmentParametersParser
import XcodeProjectChecksumCalculator
import RemoteCachePreparer
import XcodeProjectPatcher
import XcodeProjectBuilder
import ArgumentsParser

public final class CommandRunner {
    
    public init() {}
    
    public func run() -> Int32 {
        
        var registry = CommandRegistry(
            usage: "<subcommand> <options>",
            overview: "Runs specific tasks related to remote cache"
        )
        
        registry.register(command: PrepareRemoteCacheCommand.self)
        registry.register(command: ParseXcodeBuildEnvironmentParametersCommand.self)
        registry.register(command: CalculateXcodeProjectChecksumCommand.self)
        registry.register(command: CalculateXcodeProjectChecksumDiffCommand.self)
        registry.register(command: BuildXcodeProjectCommand.self)
        registry.register(command: PatchXcodeProjectCommand.self)
        
        let exitCode: Int32
        do {
            try registry.run()
            exitCode = 0
        } catch {
            exitCode = 1
            print("\(error)")
        }

        return exitCode
    }
    
}
