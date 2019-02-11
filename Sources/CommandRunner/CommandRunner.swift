import ArgumentsParser
import FrameworkBuilder
import TargetHashCalculator

public final class CommandRunner {
    
    public init() {}
    
    public func run() -> Int32 {
        
        var registry = CommandRegistry(
            usage: "<subcommand> <options>",
            overview: "Runs specific tasks related to iOS UI testing"
        )
        
        registry.register(command: BuildCommand.self)
        registry.register(command: TargetHashCommand.self)
        
        let exitCode: Int32
        do {
            try registry.run()
            exitCode = 0
        } catch {
            exitCode = 1
        }

        return exitCode
    }
    
}
