import Foundation
import SPMUtility
import Basic

public final class CommandRegistry {
    
    private let parser: ArgumentParser
    private var commands: [Command] = []
    
    public init(usage: String, overview: String) {
        parser = ArgumentParser(usage: usage, overview: overview)
    }
    
    public func register(command: Command.Type) {
        commands.append(command.init(parser: parser))
    }
    
    public func command(for arguments: [String]) throws -> (Command, ArgumentParser.Result) {
        let parsedArguments = try parse(arguments: arguments)
        let command = try process(arguments: parsedArguments)
        return (command, parsedArguments)
    }
    
    private func parse(arguments: [String]) throws -> ArgumentParser.Result {
        return try parser.parse(arguments)
    }
    
    private func process(arguments: ArgumentParser.Result) throws -> Command {
        guard let subparser = arguments.subparser(parser),
            let command = commands.first(where: { $0.command == subparser }) else {
                let stream = BufferedOutputByteStream()
                parser.printUsage(on: stream)
                guard let description = stream.bytes.validDescription else {
                    throw CommandExecutionError.unableToGenerateDescription
                }
                throw CommandExecutionError.incorrectUsage(usageDescription: description)
        }
        return command
    }
}
