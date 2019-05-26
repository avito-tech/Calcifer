import XcodeBuildEnvironmentParametersParser
import BuildProductCacheStorage
import ArgumentsParser
import Foundation
import ShellCommand
import Utility
import Toolkit

public final class UploadRemoteCacheCommand: Command {
    
    public let command = "uploadRemoteCache"
    public let overview = "Upload remote cache"
    
    enum Arguments: String, CommandArgument {
        case environmentFilePath
    }
    
    private let environmentFilePathArgument: OptionArgument<String>
    
    public required init(parser: ArgumentParser) {
        let subparser = parser.add(subparser: command, overview: overview)
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
        
        let fileManager = FileManager.default
        let unzip = Unzip(shellExecutor: ShellCommandExecutorImpl())
        let buildTargetChecksumProviderFactory = BuildTargetChecksumProviderFactoryImpl(
            fileManager: fileManager
        )
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

        try TimeProfiler.measure("Upload remote cache") {
            try uploader.upload(params: params)
        }
    }

}
