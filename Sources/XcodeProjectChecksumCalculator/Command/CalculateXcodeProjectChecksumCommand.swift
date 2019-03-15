import ArgumentsParser
import Foundation
import Utility
import Checksum
import Toolkit

public final class CalculateXcodeProjectChecksumCommand: Command {
    
    public let command = "checksum"
    public let overview = "Calculate checksum for project"
    
    enum Arguments: String, CommandArgument {
        case projectPath
    }
    
    private let projectPathArgument: OptionArgument<String>
    
    public required init(parser: ArgumentParser) {
        let subparser = parser.add(subparser: command, overview: overview)
        projectPathArgument = subparser.add(
            option: Arguments.projectPath.optionString,
            kind: String.self,
            usage: "Specify Pods project path"
        )
    }
    
    public func run(with arguments: ArgumentParser.Result) throws {
        let projectPath = try ArgumentsReader.validateNotNil(
            arguments.get(self.projectPathArgument),
            name: Arguments.projectPath.rawValue
        )
        let builder = XcodeProjChecksumHolderBuilderFactory().projChecksumHolderBuilder(
            checksumProducer: BaseURLChecksumProducer(
                fileManager: FileManager.default
            )
        )
        let checksumHolder = try builder.build(projectPath: projectPath)
        let data = try checksumHolder.encode()
        let outputFileURL = FileManager.default.pathToHomeDirectoryFile(name: "checkum.json")
        try data.write(to: outputFileURL)
        print(checksumHolder.checksum.stringValue)
        print(outputFileURL)
    }
}
