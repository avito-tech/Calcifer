import ArgumentsParser
import Foundation
import SPMUtility
import Toolkit

public final class BuildStepIntegrateCommand: Command {
    
    public let command = "integrateBuildStep"
    public let overview = "Integrate remote cache build step"
    
    enum Arguments: String, CommandArgument {
        case projectPath
        case targets
        case calciferBinaryPath
    }
    
    private let projectPathArgument: OptionArgument<String>
    private let targetsArgument: OptionArgument<[String]>
    private let calciferBinaryPathArgument: OptionArgument<String>
    
    public required init(parser: ArgumentParser) {
        let subparser = parser.add(subparser: command, overview: overview)
        projectPathArgument = subparser.add(
            option: Arguments.projectPath.optionString,
            kind: String.self,
            usage: "Specify Pods project path"
        )
        targetsArgument = subparser.add(
            option: Arguments.targets.optionString,
            kind: [String].self,
            usage: "Specify target names"
        )
        calciferBinaryPathArgument = subparser.add(
            option: Arguments.calciferBinaryPath.optionString,
            kind: String.self,
            usage: "Specify path to calcifer binary"
        )
    }
    
    public func run(with arguments: ArgumentParser.Result, runner: CommandRunner) throws {
        let projectPath = try ArgumentsReader.validateNotNil(
            arguments.get(self.projectPathArgument),
            name: Arguments.projectPath.rawValue
        )
        let targets = try ArgumentsReader.validateNotNil(
            arguments.get(self.targetsArgument),
            name: Arguments.targets.rawValue
        )
        let binaryPath = try ArgumentsReader.validateNotNil(
            arguments.get(self.calciferBinaryPathArgument),
            name: Arguments.calciferBinaryPath.rawValue
        )
        let patcher = BuildStepIntegrator()
        try patcher.integrate(
            projectPath: projectPath,
            targets: targets,
            binaryPath: binaryPath
        )
    }
}
