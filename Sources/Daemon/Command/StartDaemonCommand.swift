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
        let calciferPathProvider = CalciferPathProviderImpl(fileManager: fileManager)
        let calciferDirectory = calciferPathProvider.calciferDirectory()
        let calciferConfigProvider = CalciferConfigProvider(calciferDirectory: calciferDirectory)
        let buildProductCacheStorageWarmerFactory = createBuildProductCacheStorageWarmerFactory(
            fileManager: fileManager,
            calciferPathProvider: calciferPathProvider,
            calciferConfigProvider: calciferConfigProvider
        )
        let cleaneWarmerFactory = CleaneWarmerFactory(
            fileManager: fileManager,
            calciferPathProvider: calciferPathProvider,
            calciferConfigProvider: calciferConfigProvider
        )
        let warmerFactory = WarmerManagerFactory(
            fileManager: fileManager,
            xcodeProjCache: cacheProvider.xcodeProjCache,
            buildProductCacheStorageWarmerFactory: buildProductCacheStorageWarmerFactory,
            cleaneWarmerFactory: cleaneWarmerFactory
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
    
    private func createBuildProductCacheStorageWarmerFactory(
        fileManager: FileManager,
        calciferPathProvider: CalciferPathProvider,
        calciferConfigProvider: CalciferConfigProvider)
        -> BuildProductCacheStorageWarmerFactory
    {
        let fullPathProvider = BaseFileElementFullPathProvider()
        let xcodeProjCache = cacheProvider.xcodeProjCache
        let xcodeProjChecksumHolderBuilderFactory = XcodeProjChecksumHolderBuilderFactory(
            fullPathProvider: fullPathProvider,
            xcodeProjCache: xcodeProjCache
        )
        let checksumCalculator = ConcurentUpToDownChecksumCalculator()
        let checksumHolderValidator = ChecksumHolderValidatorImpl()
        let targetInfoProviderFactory = TargetInfoProviderFactory(
            checksumProducer: cacheProvider.baseURLChecksumProducer,
            xcodeProjChecksumCache: cacheProvider.baseXcodeProjChecksumCache,
            xcodeProjCache: xcodeProjCache,
            xcodeProjChecksumHolderBuilderFactory: xcodeProjChecksumHolderBuilderFactory,
            checksumCalculator: checksumCalculator,
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
            configProvider: calciferConfigProvider,
            requiredTargetsProvider: requiredTargetsProvider,
            calciferPathProvider: calciferPathProvider,
            cacheKeyBuilder: cacheKeyBuilder,
            targetInfoFilter: targetInfoFilter,
            cacheStorageFactory: cacheStorageFactory,
            fileManager: fileManager)
    }
    
}
