import XcodeBuildEnvironmentParametersParser
import BuildProductCacheStorage
import ArgumentsParser
import Foundation
import ShellCommand
import Utility
import Toolkit

public final class PrepareRemoteCacheCommand: Command {
    
    public let command = "prepareRemoteCache"
    public let overview = "Prepare remote cache"
    
    enum Arguments: String, CommandArgument {
        case sourcePath
        case environmentFilePath
    }
    
    private let environmentFilePathArgument: OptionArgument<String>
    private let sourcePathArgument: OptionArgument<String>
    
    public required init(parser: ArgumentParser) {
        let subparser = parser.add(subparser: command, overview: overview)
        sourcePathArgument = subparser.add(
            option: Arguments.sourcePath.optionString,
            kind: String.self,
            usage: "Specify source path"
        )
        environmentFilePathArgument = subparser.add(
            option: Arguments.environmentFilePath.optionString,
            kind: String.self,
            usage: "Specify environment file path"
        )
    }
    
    public func run(with arguments: ArgumentParser.Result, runner: CommandRunner) throws {
        
        let params: XcodeBuildEnvironmentParameters = try TimeProfiler.measure(
            "Parse environment parameters"
        ) {
            if let environmentFilePath = arguments.get(self.environmentFilePathArgument) {
                let data = try Data(contentsOf: URL(fileURLWithPath: environmentFilePath))
                return try JSONDecoder().decode(XcodeBuildEnvironmentParameters.self, from: data)
            } else {
                return try XcodeBuildEnvironmentParameters()
            }
        }
        
        let sourcePath: String
        if let sourcePathArgumentValue = arguments.get(self.sourcePathArgument) {
            sourcePath = sourcePathArgumentValue
        } else {
            sourcePath = try obtainSourcePath(path: params.podsRoot)
        }
        
        let fileManager = FileManager.default
        let buildTargetChecksumProviderFactory = BuildTargetChecksumProviderFactoryImpl.shared
        let requiredTargetsProvider = RequiredTargetsProviderImpl()
        let shellExecutor = ShellCommandExecutorImpl()
        let unzip = Unzip(shellExecutor: shellExecutor)
        let cacheStorageFactory = CacheStorageFactoryImpl(
            fileManager: fileManager,
            unzip: unzip
        )
        let preparer = RemoteCachePreparer(
            fileManager: fileManager,
            shellCommandExecutor: shellExecutor,
            buildTargetChecksumProviderFactory: buildTargetChecksumProviderFactory,
            requiredTargetsProvider: requiredTargetsProvider,
            cacheStorageFactory: cacheStorageFactory
        )
        
        try TimeProfiler.measure("Prepare remote cache") {
            try preparer.prepare(
                params: params,
                sourcePath: sourcePath
            )
        }
    }
    
    private func obtainSourcePath(path: String) throws -> String {
        let command = ShellCommand(
            launchPath: "/usr/bin/git",
            arguments: [
                "-C",
                "\(path)",
                "rev-parse",
                "--show-toplevel"
            ],
            environment: [:]
        )
        let shellCommandExecutor = ShellCommandExecutorImpl()
        let result = shellCommandExecutor.execute(command: command)
        guard let output = result.output,
            result.terminationStatus == 0
            else
        {
            throw RemoteCachePreparerError.unableToObtainSourcePath
        }
        // Remove trailing new line
        return output.chop()
    }
}
