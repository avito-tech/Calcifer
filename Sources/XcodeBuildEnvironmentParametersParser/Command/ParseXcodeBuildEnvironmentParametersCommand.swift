import ArgumentsParser
import Foundation
import Utility
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
    
    public func run(with arguments: ArgumentParser.Result) throws {
        let outputPath: String
        if let outputPathArgumentValue = arguments.get(self.outputPathArgument) {
            outputPath = outputPathArgumentValue
        } else {
            outputPath = FileManager.default
                .calciferDirectory()
                .appendingPathComponent("calciferenv.json")
        }
        let params = try XcodeBuildEnvironmentParameters()
        let data = try params.encode()
        try data.write(to: URL(fileURLWithPath: outputPath))
        print(outputPath)
    }
    
}
