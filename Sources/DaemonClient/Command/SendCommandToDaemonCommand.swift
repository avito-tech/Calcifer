import Foundation
import XcodeBuildEnvironmentParametersParser
import ArgumentsParser
import ShellCommand
import DaemonModels
import Utility
import Toolkit

public final class SendCommandToDaemonCommand: Command {
    
    public let command = "sendCommandToDaemon"
    public let overview = "Send prepareRemoteCache command to daemon"
    
    enum Arguments: String, CommandArgument {
        case commandName
        case commandArguments
    }
    
    private let commandNameArgument: OptionArgument<String>
    private let commandArgumentsArgument: OptionArgument<String>
    
    public required init(parser: ArgumentParser) {
        let subparser = parser.add(subparser: command, overview: overview)
        commandNameArgument = subparser.add(
            option: Arguments.commandName.optionString,
            kind: String.self,
            usage: "Specify command name"
        )
        commandArgumentsArgument = subparser.add(
            option: Arguments.commandArguments.optionString,
            kind: String.self,
            usage: "Specify argument"
        )
    }
    
    public func run(with arguments: ArgumentParser.Result, runner: CommandRunner) throws {
        
        let commandName = try ArgumentsReader.validateNotNil(
            arguments.get(self.commandNameArgument),
            name: Arguments.commandName.rawValue
        )
        let commandArguments = arguments.get(self.commandArgumentsArgument)
        
        guard let daemonURL = URL(string: "ws://localhost:9080/daemon") else {
            return
        }
        
        if let environmentParams = try? XcodeBuildEnvironmentParameters() {
            let fileManager = FileManager.default
            let calciferPathProvider = CalciferPathProviderImpl(fileManager: fileManager)
            let environmentFilePath = calciferPathProvider.calciferEnvironmentFilePath()
            try environmentParams.save(to: environmentFilePath)
        }
        
        let daemonClient = DaemonClientImpl(daemonURL: daemonURL)
        var arguments = [commandName]
        if let commandArguments = commandArguments {
            arguments = arguments + commandArguments.split(separator: " ").map { String($0) }
        }
        let commandRunConfig = CommandRunConfig(arguments: arguments)
        try TimeProfiler.measure("send command to daemon") {
            try daemonClient.sendToDaemon(commandRunConfig: commandRunConfig)
        }
    }
    
}

