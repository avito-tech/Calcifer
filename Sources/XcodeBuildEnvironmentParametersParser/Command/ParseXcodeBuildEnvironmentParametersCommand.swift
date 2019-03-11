import ArgumentsParser
import Foundation
import Utility
import Toolkit

public final class ParseXcodeBuildEnvironmentParametersCommand: Command {
    
    public let command = "parseXcodeBuildEnvironmentParameters"
    public let overview = "Parse xcodebuild environment parameters"
    
    public required init(parser: ArgumentParser) {
        parser.add(subparser: command, overview: overview)
    }
    
    public func run(with arguments: ArgumentParser.Result) throws {
        
        let params = try XcodeBuildEnvironmentParameters()
        let flags = LinkerFlagParser().parse(linkerFlags: params.otherLDFlags)
        let frameworks = flags.compactMap { $0.framework?.name }
        
        let outputFilePath = FileManager.default.pathToHomeDirectoryFile(name: "environment.txt")
        try "\(frameworks)".description.write(to: outputFilePath, atomically: false, encoding: .utf8)
        print(outputFilePath)
    }
    
}
