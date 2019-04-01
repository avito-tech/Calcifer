import XcodeBuildEnvironmentParametersParser
import XcodeProjectChecksumCalculator
import RemoteCachePreparer
import XcodeProjectPatcher
import XcodeProjectBuilder
import ArgumentsParser
import DSYMSymbolizer
import Toolkit

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
        registry.register(command: SymbolizeDSYMCommand.self)
        
        let exitCode: Int32
        do {
            try TimeProfiler.measure("Execute command") {
                try registry.run()
            }
            exitCode = 0
        } catch {
            exitCode = 1
            Logger.error("error: \(error)")
            // `error` for xcode log highlighting
            print("error: \(error)")
        }

        return exitCode
    }
    
}
