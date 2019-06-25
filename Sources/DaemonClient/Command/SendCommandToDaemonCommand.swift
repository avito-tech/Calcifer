import Foundation
import XcodeBuildEnvironmentParametersParser
import ArgumentsParser
import ShellCommand
import DaemonModels
import CalciferConfig
import SPMUtility
import Toolkit

public final class SendCommandToDaemonCommand: Command {
    
    public let command = "sendCommandToDaemon"
    public let overview = "Send command to daemon"
    
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
        let environmentFilePath = calciferPathProvider.calciferEnvironmentFilePath()
        
        let params = try obtainEnvironmentParams(
            with: arguments,
            fileManager: fileManager,
            environmentFilePath: environmentFilePath
        )
        
        let config = try configProvider.obtainConfig(
            projectDirectoryPath: params.projectDirectory
        )
        let daemonClient = try createDaemonClient(daemonConfig: config.daemonConfig)
        let commandRunConfig = createCommandRunConfig(
            commandName: commandName,
            commandArguments: commandArguments
        )
        try TimeProfiler.measure("send command to daemon") {
            try daemonClient.sendToDaemon(commandRunConfig: commandRunConfig)
        }
    }
    
    private func createCommandRunConfig(
        commandName: String,
        commandArguments: String?)
        -> CommandRunConfig
    {
        var arguments = [commandName]
        if let commandArguments = commandArguments {
            arguments += commandArguments.split(separator: " ").map { String($0) }
        }
        return CommandRunConfig(
            identifier: UUID().uuidString,
            arguments: arguments
        )
    }
    
    private func createDaemonClient(daemonConfig: DaemonConfig) throws -> DaemonClient {
        guard let daemonURL = URL(
            string: "\(daemonConfig.host):\(daemonConfig.port)/\(daemonConfig.endpoint)"
        ) else {
            throw DaemonClientError.unableToCreateDaemonURL
        }
        return DaemonClientImpl(daemonURL: daemonURL)
    }
    
    private func obtainEnvironmentParams(
        with arguments: ArgumentParser.Result,
        fileManager: FileManager,
        environmentFilePath: String)
        throws -> XcodeBuildEnvironmentParameters
    {
        if let environmentFilePath = arguments.get(self.environmentFilePathArgument) {
            return try XcodeBuildEnvironmentParameters.decode(from: environmentFilePath)
        } else if let environmentParams = try? XcodeBuildEnvironmentParameters() {
            let fileManager = FileManager.default
            let calciferPathProvider = CalciferPathProviderImpl(fileManager: fileManager)
            let environmentFilePath = calciferPathProvider.calciferEnvironmentFilePath()
            try environmentParams.save(to: environmentFilePath)
            return environmentParams
        } else if fileManager.fileExists(atPath: environmentFilePath) {
            return try XcodeBuildEnvironmentParameters.decode(from: environmentFilePath)
        }
        throw ArgumentsError.argumentIsMissing(Arguments.environmentFilePath.rawValue)
    }
}
