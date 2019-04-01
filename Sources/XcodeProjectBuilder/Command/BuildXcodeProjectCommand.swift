import ArgumentsParser
import Foundation
import ShellCommand
import Utility
import Toolkit

public final class BuildXcodeProjectCommand: Command {
    
    public let command = "buildXcodeProject"
    public let overview = "Builds xcode project"
    
    enum Arguments: String, CommandArgument {
        case projectPath
        case configuration
        case architecture
        case platform
    }
    
    private let builder = XcodeProjectBuilder(
        shellExecutor: ShellCommandExecutorImpl()
    )
    
    private let projectPathArgument: OptionArgument<String>
    private let configurationArgument: OptionArgument<String>
    private let architectureArgument: OptionArgument<String>
    private let platformArgument: OptionArgument<String>
    
    public required init(parser: ArgumentParser) {
        let subparser = parser.add(subparser: command, overview: overview)
        projectPathArgument = subparser.add(
            option: Arguments.projectPath.optionString,
            kind: String.self,
            usage: "Specify Pods project path"
        )
        configurationArgument = subparser.add(
            option: Arguments.configuration.optionString,
            kind: String.self,
            usage: "Specify build configuration"
        )
        architectureArgument = subparser.add(
            option: Arguments.architecture.optionString,
            kind: String.self,
            usage: "Specify architecture"
        )
        platformArgument = subparser.add(
            option: Arguments.platform.optionString,
            kind: String.self,
            usage: "Specify sdk"
        )
    }
    
    public func run(with arguments: ArgumentParser.Result) throws {
        let projectPath = try ArgumentsReader.validateNotNil(
            arguments.get(self.projectPathArgument),
            name: Arguments.projectPath.rawValue
        )
        let configuration = try ArgumentsReader.validateNotNil(
            arguments.get(self.configurationArgument),
            name: Arguments.configuration.rawValue
        )
        let architectureName = try ArgumentsReader.validateNotNil(
            arguments.get(self.architectureArgument),
            name: Arguments.architecture.rawValue
        )
        let platformName = try ArgumentsReader.validateNotNil(
            arguments.get(self.platformArgument),
            name: Arguments.platform.rawValue
        )
        
        guard let architecture = Architecture(rawValue: architectureName) else {
            throw ArgumentsError.argumentValueCannotBeUsed(Arguments.architecture.rawValue)
        }
        
        guard let platform = Platform(rawValue: platformName) else {
            throw ArgumentsError.argumentValueCannotBeUsed(
                Arguments.platform.rawValue
            )
        }
        
        let config = XcodeProjectBuildConfig(
            platform: platform,
            architecture: architecture,
            projectPath: projectPath,
            targetName: "Aggregate",
            configurationName: configuration,
            onlyActiveArchitecture: true
        )
        let environment = ProcessInfo.processInfo.environment
        try builder.build(config: config, environment: environment)
    }
}
