import XcodeBuildEnvironmentParametersParser
import BuildProductCacheStorage
import ArgumentsParser
import XcodeProjCache
import CalciferConfig
import Foundation
import ShellCommand
import SPMUtility
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
        
        let fileManager = FileManager.default
        let calciferPathProvider = CalciferPathProviderImpl(fileManager: fileManager)
        
        let params: XcodeBuildEnvironmentParameters = try TimeProfiler.measure(
            "Parse environment parameters"
        ) {
            if let environmentFilePath = arguments.get(self.environmentFilePathArgument) {
                let data = try Data(contentsOf: URL(fileURLWithPath: environmentFilePath))
                return try JSONDecoder().decode(XcodeBuildEnvironmentParameters.self, from: data)
            } else if let environmentParams = try? XcodeBuildEnvironmentParameters() {
                return environmentParams
            }
            let environmentFilePath = calciferPathProvider.calciferEnvironmentFilePath()
            if fileManager.fileExists(atPath: environmentFilePath) {
                return try XcodeBuildEnvironmentParameters.decode(from: environmentFilePath)
            }
            throw ArgumentsError.argumentIsMissing(Arguments.environmentFilePath.rawValue)
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
        
        let buildTargetChecksumProviderFactory = BuildTargetChecksumProviderFactoryImpl.shared
        let requiredTargetsProvider = RequiredTargetsProviderImpl()
        let unzip = Unzip(shellExecutor: shellExecutor)
        let cacheStorageFactory = CacheStorageFactoryImpl(
            fileManager: fileManager,
            unzip: unzip
        )
        let xcodeProjCache = XcodeProjCacheImpl.shared
        let preparer = RemoteCachePreparer(
            fileManager: fileManager,
            calciferPathProvider: calciferPathProvider,
            shellCommandExecutor: shellExecutor,
            buildTargetChecksumProviderFactory: buildTargetChecksumProviderFactory,
            requiredTargetsProvider: requiredTargetsProvider,
            cacheStorageFactory: cacheStorageFactory,
            xcodeProjCache: xcodeProjCache
        )
        let configProvider = CalciferConfigProvider(
            calciferDirectory: calciferPathProvider.calciferDirectory()
        )
        let config = try configProvider.obtainConfig(projectDirectoryPath: params.projectDirectory)
        
        try TimeProfiler.measure("Prepare remote cache") {
            try preparer.prepare(
                config: config,
                params: params,
                sourcePath: sourcePath
            )
        }
    }
    
}
