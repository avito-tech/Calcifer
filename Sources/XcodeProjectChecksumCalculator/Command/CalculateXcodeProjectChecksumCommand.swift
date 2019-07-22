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
        let fileManager = FileManager.default
        let checksumProducer = BaseURLChecksumProducer(fileManager: fileManager)
        let xcodeProjCache = XcodeProjCacheImpl(
            fileManager: fileManager,
            checksumProducer: checksumProducer
        )
        let fullPathProvider = BaseFileElementFullPathProvider()
        let xcodeProjChecksumHolderBuilderFactory = XcodeProjChecksumHolderBuilderFactory(
            fullPathProvider: fullPathProvider,
            xcodeProjCache: xcodeProjCache
        )
        let xcodeProjChecksumCache = XcodeProjChecksumCacheImpl()
        let builder = xcodeProjChecksumHolderBuilderFactory.projChecksumHolderBuilder(
            checksumProducer: checksumProducer,
            xcodeProjChecksumCache: xcodeProjChecksumCache
        )
        let xcodeProj = try TimeProfiler.measure("Obtain XcodeProj") {
            try xcodeProjCache.obtainXcodeProj(projectPath: projectPath)
        }
        let checksumHolder = try builder.build(
            xcodeProj: xcodeProj,
            projectPath: projectPath
        )
        let codableChecksumNode = checksumHolder.node()
        let data = try codableChecksumNode.encode()
        let outputFileURL = fileManager.pathToHomeDirectoryFile(name: "checksum.json")
        try data.write(to: outputFileURL)
        print(codableChecksumNode.value)
        print(outputFileURL)
    }
}
