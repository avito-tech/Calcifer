import ArgumentsParser
import XcodeProjCache
import Foundation
import SPMUtility
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
    
    public func run(with arguments: ArgumentParser.Result, runner: CommandRunner) throws {
        let projectPath = try ArgumentsReader.validateNotNil(
            arguments.get(self.projectPathArgument),
            name: Arguments.projectPath.rawValue
        )
        let factory = XcodeProjChecksumHolderBuilderFactory(
            fullPathProvider: BaseFileElementFullPathProvider(),
            xcodeProjCache: XcodeProjCacheImpl.shared
        )
        let builder = factory.projChecksumHolderBuilder(
            checksumProducer: BaseURLChecksumProducer(
                fileManager: FileManager.default
            )
        )
        let xcodeProj = try TimeProfiler.measure("Obtain XcodeProj") {
            try XcodeProjCacheImpl.shared.obtainXcodeProj(projectPath: projectPath)
        }
        let checksumHolder = try builder.build(
            xcodeProj: xcodeProj,
            projectPath: projectPath
        )
        let codableChecksumNode = checksumHolder.node()
        let data = try codableChecksumNode.encode()
        let outputFileURL = FileManager.default.pathToHomeDirectoryFile(name: "сhecksum.json")
        try data.write(to: outputFileURL)
        print(codableChecksumNode.value)
        print(outputFileURL)
    }
}
