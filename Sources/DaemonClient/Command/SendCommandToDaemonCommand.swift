import Foundation
import XcodeBuildEnvironmentParametersParser
import ArgumentsParser
import ShellCommand
import DaemonModels
import CalciferConfig
import Utility
import Toolkit

public final class SendCommandToDaemonCommand: Command {
    
    public let command = "sendCommandToDaemon"
    public let overview = "Send prepareRemoteCache command to daemon"
    
    enum Arguments: String, CommandArgument {
        case commandName
        case commandArguments
        case environmentFilePath
    }
    
    private let commandNameArgument: OptionArgument<String>
    private let commandArgumentsArgument: OptionArgument<String>
    private let environmentFilePathArgument: OptionArgument<String>
    
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
        environmentFilePathArgument = subparser.add(
            option: Arguments.environmentFilePath.optionString,
            kind: String.self,
            usage: "Specify environment file path"
        )
    }
    
    public func run(with arguments: ArgumentParser.Result, runner: CommandRunner) throws {
        
        let commandName = try ArgumentsReader.validateNotNil(
            arguments.get(self.commandNameArgument),
            name: Arguments.commandName.rawValue
        )
        let commandArguments = arguments.get(self.commandArgumentsArgument)
        
        let fileManager = FileManager.default
        let calciferPathProvider = CalciferPathProviderImpl(fileManager: fileManager)
        let configProvider = CalciferConfigProvider(
            calciferDirectory: calciferPathProvider.calciferDirectory()
        )
        
        let params: XcodeBuildEnvironmentParameters
        if let environmentFilePath = arguments.get(self.environmentFilePathArgument) {
            let data = try Data(contentsOf: URL(fileURLWithPath: environmentFilePath))
            params = try JSONDecoder().decode(XcodeBuildEnvironmentParameters.self, from: data)
        } else if let environmentParams = try? XcodeBuildEnvironmentParameters() {
            let fileManager = FileManager.default
            let calciferPathProvider = CalciferPathProviderImpl(fileManager: fileManager)
            let environmentFilePath = calciferPathProvider.calciferEnvironmentFilePath()
            try environmentParams.save(to: environmentFilePath)
            params = environmentParams
        } else {
            let environmentFilePath = calciferPathProvider.calciferEnvironmentFilePath()
            if fileManager.fileExists(atPath: environmentFilePath) {
                params = try XcodeBuildEnvironmentParameters.decode(from: environmentFilePath)
            }
            throw ArgumentsError.argumentIsMissing(Arguments.environmentFilePath.rawValue)
        }
        
        let config = try configProvider.obtainConfig(
            projectDirectoryPath: params.projectDirectory
        )
        let daemonConfig = config.daemonConfig
        guard let daemonURL = URL(string: "\(daemonConfig.host):\(daemonConfig.port)/\(daemonConfig.endpoint)") else {
            return
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

