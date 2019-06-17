import ArgumentsParser
import Foundation
import SPMUtility
import Toolkit

public final class ParseXcodeBuildEnvironmentParametersCommand: Command {
    
    public let command = "parseXcodeBuildEnvironmentParameters"
    public let overview = "Parse xcodebuild environment parameters"
    
    enum Arguments: String, CommandArgument {
        case outputPath
    }
    
    private let outputPathArgument: OptionArgument<String>
    
    public required init(parser: ArgumentParser) {
        let subparser = parser.add(subparser: command, overview: overview)
        outputPathArgument = subparser.add(
            option: Arguments.outputPath.optionString,
            kind: String.self,
            usage: "Specify output path"
        )
    }
    
    public func run(with arguments: ArgumentParser.Result, runner: CommandRunner) throws {
        let outputPath: String
        let fileManager = FileManager.default
        if let outputPathArgumentValue = arguments.get(self.outputPathArgument) {
            outputPath = outputPathArgumentValue
        } else {
            let calciferPathProvider = CalciferPathProviderImpl(fileManager: fileManager)
            outputPath = calciferPathProvider
                .calciferDirectory()
                .appendingPathComponent("calciferenv.json")
        }
        let params = try XcodeBuildEnvironmentParameters()
        try params.save(to: outputPath)
        print(outputPath)
    }
    
}
