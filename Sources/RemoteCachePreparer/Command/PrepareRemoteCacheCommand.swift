import XcodeBuildEnvironmentParametersParser
import BuildProductCacheStorage
import ArgumentsParser
import XcodeProjCache
import CalciferConfig
import Foundation
import ShellCommand
import SPMUtility
import Checksum
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
        let environmentFilePath = calciferPathProvider.calciferEnvironmentFilePath()
        
        let params = try obtainEnvironmentParams(
            with: arguments,
            fileManager: fileManager,
            environmentFilePath: environmentFilePath
        )
        
        let shellExecutor = ShellCommandExecutorImpl()
        let sourcePath = try obtainSourcePath(
            with: arguments,
            shellExecutor: shellExecutor,
            params: params
        )
        
        let configProvider = CalciferConfigProvider(
            calciferDirectory: calciferPathProvider.calciferDirectory()
        )
        let config = try configProvider.obtainConfig(
            projectDirectoryPath: params.projectDirectory
        )
        let preparer = createPreparer(
            fileManager: fileManager,
            calciferPathProvider: calciferPathProvider,
            shellExecutor: shellExecutor
        )
        
        let checksumProducer = BaseURLChecksumProducer.shared
        
        try TimeProfiler.measure("Prepare remote cache") {
            try preparer.prepare(
                config: config,
                params: params,
                checksumProducer: checksumProducer,
                sourcePath: sourcePath
            )
        }
    }
    
    private func createPreparer(
        fileManager: FileManager,
        calciferPathProvider: CalciferPathProvider,
        shellExecutor: ShellCommandExecutor)
        -> RemoteCachePreparer
    {
        let buildTargetChecksumProviderFactory = BuildTargetChecksumProviderFactoryImpl.shared
        let requiredTargetsProvider = RequiredTargetsProviderImpl()
        let unzip = Unzip(shellExecutor: shellExecutor)
        let cacheStorageFactory = CacheStorageFactoryImpl(
            fileManager: fileManager,
            unzip: unzip
        )
        let xcodeProjCache = XcodeProjCacheImpl.shared
        let artifactBuildSourcePathCache = ArtifactBuildSourcePathCacheImpl.shared
        return RemoteCachePreparer(
            fileManager: fileManager,
            calciferPathProvider: calciferPathProvider,
            shellCommandExecutor: shellExecutor,
            buildTargetChecksumProviderFactory: buildTargetChecksumProviderFactory,
            requiredTargetsProvider: requiredTargetsProvider,
            cacheStorageFactory: cacheStorageFactory,
            xcodeProjCache: xcodeProjCache,
            artifactBuildSourcePathCache: artifactBuildSourcePathCache
        )
    }
    
    private func obtainSourcePath(
        with arguments: ArgumentParser.Result,
        shellExecutor: ShellCommandExecutor,
        params: XcodeBuildEnvironmentParameters)
        throws -> String
    {
        if let sourcePathArgumentValue = arguments.get(self.sourcePathArgument) {
            return sourcePathArgumentValue
        }
        let sourcePathProvider = SourcePathProviderImpl(
            shellCommandExecutor: shellExecutor
        )
        return try sourcePathProvider.obtainSourcePath(
            podsRoot: params.podsRoot
        )
    }
    
    private func obtainEnvironmentParams(
        with arguments: ArgumentParser.Result,
        fileManager: FileManager,
        environmentFilePath: String)
        throws -> XcodeBuildEnvironmentParameters
    {
        if let filePath = arguments.get(self.environmentFilePathArgument) {
            return try XcodeBuildEnvironmentParameters.decode(from: filePath)
        } else if let environmentParams = try? XcodeBuildEnvironmentParameters() {
            let fileManager = FileManager.default
            let calciferPathProvider = CalciferPathProviderImpl(fileManager: fileManager)
            let environmentFilePath = calciferPathProvider.calciferEnvironmentFilePath()
            try environmentParams.save(to: environmentFilePath)
            return environmentParams
        } else if fileManager.fileExists(atPath: environmentFilePath) {
            return try XcodeBuildEnvironmentParameters.decode(from: environmentFilePath)
        }
        throw ArgumentsError.argumentIsMissing(Arguments.environmentFilePath.rawValue)
    }
    
}
