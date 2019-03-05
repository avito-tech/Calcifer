import ArgumentsParser
import Foundation
import Utility
import Toolkit

public final class ProjectChecksumCommand: Command {
    
    public let command = "checksum"
    public let overview = "Calculate checksum for project"
    
    enum Arguments: String {
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
            checksumProducer: BaseURLChecksumProducer()
        )
        let checksumHolder = try builder.build(projectPath: projectPath)
        let data = try checksumHolder.encode()
        let outputFilePath = FileManager.default.file(name: "checkum.json")
        try data.write(to: outputFilePath)
        print(checksumHolder.checksum.description)
        print(outputFilePath)
    }
}
