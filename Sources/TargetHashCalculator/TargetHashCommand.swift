import ArgumentsParser
import Foundation
import Utility

public final class TargetHashCommand: Command {
    
    public let command = "hash"
    public let overview = "Calculate hash for target"
    
    enum Arguments: String {
        case projectPath
        case targetName
    }
    
    private let сalculator = TargetHashCalculator()
    
    private let projectPathArgument: OptionArgument<String>
    private let targetNameArgument: OptionArgument<String>
    
    required public init(parser: ArgumentParser) {
        let subparser = parser.add(subparser: command, overview: overview)
        projectPathArgument = subparser.add(
            option: "--\(Arguments.projectPath.rawValue)",
            kind: String.self,
            usage: "Specify Pods project path"
        )
        targetNameArgument = subparser.add(
            option: "--\(Arguments.targetName.rawValue)",
            kind: String.self,
            usage: "Specify target name"
        )
    }
    
    public func run(with arguments: ArgumentParser.Result) throws {
        debugPrint("Calculate hash")
        let projectPath = try ArgumentsReader.validateNotNil(
            arguments.get(self.projectPathArgument),
            name: Arguments.projectPath.rawValue
        )
        let targetName = try ArgumentsReader.validateNotNil(
            arguments.get(self.targetNameArgument),
            name: Arguments.targetName.rawValue
        )
        debugPrint("projectPath: \(projectPath) targetName: \(targetName)")
        сalculator.calculate(
            projectPath: projectPath,
            targetName: targetName
        )
    }
}
