import XcodeBuildEnvironmentParametersParser
import BuildProductCacheStorage
import ArgumentsParser
import CalciferConfig
import ShellCommand
import Foundation
import Utility
import Toolkit

public final class UploadRemoteCacheCommand: Command {
    
    public let command = "uploadRemoteCache"
    public let overview = "Upload remote cache"
    
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
        
        let shellExecutor = ShellCommandExecutorImpl()
        
        let sourcePath: String
        if let sourcePathArgumentValue = arguments.get(self.sourcePathArgument) {
            sourcePath = sourcePathArgumentValue
        } else {
            let sourcePathProvider = SourcePathProviderImpl(
                shellCommandExecutor: shellExecutor
            )
            sourcePath = try sourcePathProvider.obtainSourcePath(
                podsRoot: params.podsRoot
            )
        }
        
        let fileManager = FileManager.default
        let unzip = Unzip(shellExecutor: ShellCommandExecutorImpl())
        let buildTargetChecksumProviderFactory = BuildTargetChecksumProviderFactoryImpl.shared
        let requiredTargetsProvider = RequiredTargetsProviderImpl()
        let cacheStorageFactory = CacheStorageFactoryImpl(
            fileManager: fileManager,
            unzip: unzip
        )
        let uploader = RemoteCacheUploader(
            fileManager: fileManager,
            buildTargetChecksumProviderFactory: buildTargetChecksumProviderFactory,
            requiredTargetsProvider: requiredTargetsProvider,
            cacheStorageFactory: cacheStorageFactory
        )
        
        let configProvider = CalciferConfigProvider(fileManager: fileManager)
        let config = try configProvider.obtainConfig(path: sourcePath)

        try TimeProfiler.measure("Upload remote cache") {
            try uploader.upload(config: config, params: params)
        }
    }

}
