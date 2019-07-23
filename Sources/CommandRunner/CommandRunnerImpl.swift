import Foundation
import ArgumentsParser
import Toolkit

public final class CommandRunnerImpl: CommandRunner {
    
    public let registry = CommandRegistry(
        usage: "<subcommand> <options>",
        overview: "Runs specific tasks related to remote cache"
    )
    
    private var loggerConfigured: Bool = false
    
    public init() {}
    
    public func register(commands: [Command.Type]) {
        for commandType in commands {
            registry.register(command: commandType)
        }
    }
    
    public func run(config: CommandRunConfig) -> Int32 {
        let exitCode: Int32
        do {
            try TimeProfiler.measure("Execute command") {
                let (command, parsedArguments) = try registry.command(for: config.arguments)
                if loggerConfigured == false {
                    Logger.addFileDestination(folderName: command.command)
                    loggerConfigured = true
                }
                try command.run(with: parsedArguments, runner: self)
            }
            exitCode = 0
        } catch {
            exitCode = 1
            Logger.error("\(error)")
            // `error` for xcode log highlighting
            print("error: \(error)")
        }
        
        return exitCode
    }
    
}
