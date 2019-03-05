import ArgumentsParser
import Foundation
import Utility
import Toolkit

public final class BuildCommand: Command {
    
    public let command = "build"
    public let overview = "Builds the necessary frameworks"
    
    enum Arguments: String {
        case projectPath
        case configuration
        case architecture
        case SDK
    }
    
    private let builder = FrameworkBuilder()
    
    private let projectPathArgument: OptionArgument<String>
    private let configurationArgument: OptionArgument<String>
    private let architectureArgument: OptionArgument<String>
    private let sdkArgument: OptionArgument<String>
    
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
        sdkArgument = subparser.add(
            option: Arguments.SDK.optionString,
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
        let sdkName = try ArgumentsReader.validateNotNil(
            arguments.get(self.sdkArgument),
            name: Arguments.SDK.rawValue
        )
        
        guard let architecture = BuildConfig.Architecture(rawValue: architectureName) else {
            throw ArgumentsError.argumentValueCannotBeUsed(Arguments.architecture.rawValue)
        }
        
        guard let sdk = BuildConfig.SDK(rawValue: sdkName) else {
            throw ArgumentsError.argumentValueCannotBeUsed(
                Arguments.SDK.rawValue
            )
        }
        
        let config = BuildConfig(
            SDK: sdk,
            architecture: architecture,
            projectPath: projectPath,
            targetName: "Aggregate",
            configurationName: configuration,
            onlyActiveArchitecture: true
        )
        builder.build(config: config)
    }
}
