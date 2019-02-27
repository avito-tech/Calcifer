import ArgumentsParser
import Foundation
import Utility

public final class ProjectChecksumCommand: Command {
    
    public let command = "checksum"
    public let overview = "Calculate checksum for project"
    
    enum Arguments: String {
        case projectPath
        case productName
    }
    
    private let сalculator = ProjectChecksumCalculator()
    
    private let projectPathArgument: OptionArgument<String>
    
    required public init(parser: ArgumentParser) {
        let subparser = parser.add(subparser: command, overview: overview)
        projectPathArgument = subparser.add(
            option: "--\(Arguments.projectPath.rawValue)",
            kind: String.self,
            usage: "Specify Pods project path"
        )
    }
    
    public func run(with arguments: ArgumentParser.Result) throws {
        let projectPath = try ArgumentsReader.validateNotNil(
            arguments.get(self.projectPathArgument),
            name: Arguments.projectPath.rawValue
        )
        let checksum = try сalculator.calculate(
            projectPath: projectPath
        )
        print(checksum ?? "-")
    }
}
