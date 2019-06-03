import ArgumentsParser
import XcodeBuildEnvironmentParametersParser
import XcodeProjCache
import Foundation
import Utility
import Toolkit

public final class PatchXcodeProjectCommand: Command {
    
    public let command = "patchXcodeProject"
    public let overview = "Patch xcode project"
    
    enum Arguments: String, CommandArgument {
        case projectPath
        case outputPath
        case targets
        case environmentFilePath
    }
    
    private let projectPathArgument: OptionArgument<String>
    private let outputPathArgument: OptionArgument<String>
    private let targetsArgument: OptionArgument<[String]>
    private let environmentFilePathArgument: OptionArgument<String>
    
    
    public required init(parser: ArgumentParser) {
        let subparser = parser.add(subparser: command, overview: overview)
        projectPathArgument = subparser.add(
            option: Arguments.projectPath.optionString,
            kind: String.self,
            usage: "Specify Pods project path"
        )
        outputPathArgument = subparser.add(
            option: Arguments.outputPath.optionString,
            kind: String.self,
            usage: "Specify output path"
        )
        targetsArgument = subparser.add(
            option: Arguments.targets.optionString,
            kind: [String].self,
            usage: "Specify targets name"
        )
        environmentFilePathArgument = subparser.add(
            option: Arguments.environmentFilePath.optionString,
            kind: String.self,
            usage: "Specify environment file path"
        )
    }
    
    public func run(with arguments: ArgumentParser.Result, runner: CommandRunner) throws {
        let projectPath = try ArgumentsReader.validateNotNil(
            arguments.get(self.projectPathArgument),
            name: Arguments.projectPath.rawValue
        )
        let outputPath = try ArgumentsReader.validateNotNil(
            arguments.get(self.outputPathArgument),
            name: Arguments.outputPath.rawValue
        )
        let targets = try ArgumentsReader.validateNotNil(
            arguments.get(self.targetsArgument),
            name: Arguments.targets.rawValue
        )
        let params: XcodeBuildEnvironmentParameters = try TimeProfiler.measure(
            "Parse environment parameters"
        ) {
            if let environmentFilePath = arguments.get(self.environmentFilePathArgument) {
                let data = try Data(contentsOf: URL(fileURLWithPath: environmentFilePath))
                return try JSONDecoder().decode(XcodeBuildEnvironmentParameters.self, from: data)
            } else {
                return try XcodeBuildEnvironmentParameters()
            }
        }
        let patcher = XcodeProjectPatcher(
            xcodeProjCache: XcodeProjCacheImpl.shared,
            fileManager: FileManager.default
        )
        try patcher.patch(
            projectPath: projectPath,
            outputPath: outputPath,
            targets: targets,
            params: params
        )
    }
}
