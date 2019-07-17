import Foundation
import XcodeProjectChecksumCalculator
import BuildProductCacheStorage
import RemoteCachePreparer
import ArgumentsParser
import CalciferConfig
import ShellCommand
import SPMUtility
import Checksum
import Toolkit
import Warmer

public final class StartDaemonCommand: Command {
    
    public let command = "startDaemon"
    public let overview = "Start daemon with sever"
    
    public required init(parser: ArgumentParser) {
        parser.add(subparser: command, overview: overview)
    }
    
    public func run(with arguments: ArgumentParser.Result, runner: CommandRunner) throws {
        // If another daemon instance is already running, new instance will die because socket is already reserved/busy
        Logger.info("Run daemon pid \(getpid())")
        
        let operationQueue = OperationQueue.createSerialQueue(
            qualityOfService: .userInitiated
        )
        let fileManager = cacheProvider.fileManager
        let buildProductCacheStorageWarmerFactory = createBuildProductCacheStorageWarmerFactory()
        let warmerFactory = WarmerManagerFactory(
            fileManager: fileManager,
            xcodeProjCache: cacheProvider.xcodeProjCache,
            buildProductCacheStorageWarmerFactory: buildProductCacheStorageWarmerFactory
        )
        let warmerManager = warmerFactory.createWarmerManager(
            warmupOperationQueue: operationQueue
        )
        let daemon = Daemon(
            commandRunOperationQueue: operationQueue,
            commandRunner: runner,
            warmerManager: warmerManager
        )
        try daemon.run()
    }
    
    private func createBuildProductCacheStorageWarmerFactory() -> BuildProductCacheStorageWarmerFactory {
        let fileManager = cacheProvider.fileManager
        let calciferPathProvider = CalciferPathProviderImpl(fileManager: fileManager)
        let calciferDirectory = calciferPathProvider.calciferDirectory()
        let configProvider = CalciferConfigProvider(calciferDirectory: calciferDirectory)
        let fullPathProvider = BaseFileElementFullPathProvider()
        let xcodeProjCache = cacheProvider.xcodeProjCache
        let xcodeProjChecksumHolderBuilderFactory = XcodeProjChecksumHolderBuilderFactory(
            fullPathProvider: fullPathProvider,
            xcodeProjCache: xcodeProjCache
        )
        let checksumHolderValidator = ChecksumHolderValidatorImpl()
        let targetInfoProviderFactory = TargetInfoProviderFactory(
            checksumProducer: cacheProvider.baseURLChecksumProducer,
            xcodeProjChecksumCache: cacheProvider.baseXcodeProjChecksumCache,
            xcodeProjCache: xcodeProjCache,
            xcodeProjChecksumHolderBuilderFactory: xcodeProjChecksumHolderBuilderFactory,
            checksumHolderValidator: checksumHolderValidator
        )
        let targetInfoFilter = TargetInfoFilter()
        let requiredTargetsProvider = RequiredTargetsProviderImpl(
            targetInfoProviderFactory: targetInfoProviderFactory,
            targetInfoFilter: targetInfoFilter
        )
        let cacheKeyBuilder = BuildProductCacheKeyBuilder()
        let shellExecutor = ShellCommandExecutorImpl()
        let unzip = Unzip(shellExecutor: shellExecutor)
        let cacheStorageFactory = CacheStorageFactoryImpl(
            fileManager: fileManager,
            unzip: unzip
        )
        return BuildProductCacheStorageWarmerFactory(
            configProvider: configProvider,
            requiredTargetsProvider: requiredTargetsProvider,
            calciferPathProvider: calciferPathProvider,
            cacheKeyBuilder: cacheKeyBuilder,
            targetInfoFilter: targetInfoFilter,
            cacheStorageFactory: cacheStorageFactory)
    }
    
}
