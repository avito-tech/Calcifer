import ArgumentsParser
import Foundation
import Utility
import Toolkit

public final class ProjectPatcherCommand: Command {
    
    public let command = "patch"
    public let overview = "Patch project"
    
    enum Arguments: String {
        case projectPath
        case outputPath
        case targets
    }
    
    private let projectPathArgument: OptionArgument<String>
    private let outputPathArgument: OptionArgument<String>
    private let targetsArgument: OptionArgument<[String]>
    
    public required init(parser: ArgumentParser) {
        let subparser = parser.add(subparser: command, overview: overview)
        projectPathArgument = subparser.add(
            option: "--\(Arguments.projectPath.rawValue)",
            kind: String.self,
            usage: "Specify Pods project path"
        )
        outputPathArgument = subparser.add(
            option: "--\(Arguments.outputPath.rawValue)",
            kind: String.self,
            usage: "Specify output path"
        )
        targetsArgument = subparser.add(
            option: "--\(Arguments.targets.rawValue)",
            kind: [String].self,
            usage: "Specify targets name"
        )
    }
    
    public func run(with arguments: ArgumentParser.Result) throws {
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
        let patcher = ProjectPatcher()
        try patcher.patch(
            projectPath: projectPath,
            outputPath: outputPath,
            targets: targets
        )
    }
}
