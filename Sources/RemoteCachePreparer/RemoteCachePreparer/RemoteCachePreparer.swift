import Foundation
import XcodeBuildEnvironmentParametersParser
import XcodeProjectChecksumCalculator
import BuildProductCacheStorage
import XcodeProjectBuilder
import XcodeProjectPatcher
import BuildArtifacts
import DSYMSymbolizer
import ShellCommand
import Checksum
import Toolkit

final class RemoteCachePreparer {
    
    private let fileManager: FileManager
    private let cacheKeyBuilder = BuildProductCacheKeyBuilder()
    private let shellCommandExecutor = ShellCommandExecutorImpl()
    
    init(fileManager: FileManager) {
        self.fileManager = fileManager
    }
    
    func prepare(params: XcodeBuildEnvironmentParameters, sourcePath: String) throws {
        let podsProjectPath = params.podsProjectPath
        
        let checksumProducer = BaseURLChecksumProducer(fileManager: fileManager)
        let paramsChecksum = try BuildParametersChecksumProducer().checksum(input: params)
        
        // TODO: save xcodeproj as json and if hash of xml same use json instead xcodeproj
        let targetChecksumProvider = try TimeProfiler.measure("Calculate checksum") {
            try createBuildTargetChecksumProvider(
                podsProjectPath: podsProjectPath,
                checksumProducer: checksumProducer
            )
        }
        
        let cacheStorage = try createCacheStorage()
        let targetInfoFilter = TargetInfoFilter(targetInfoProvider: targetChecksumProvider)
        
        let requiredTargets = try TimeProfiler.measure("Obtain required targets") {
            try targetInfoFilter.obtainRequiredTargets(
                buildParametersChecksum: paramsChecksum,
                params: params
            )
        }
        
        let buildArtifactIntegrator = BuildArtifactIntegrator(
            fileManager: fileManager,
            checksumProducer: checksumProducer
        )
        let artifactIntegrator = ArtifactIntegrator(
            integrator: buildArtifactIntegrator,
            cacheKeyBuilder: cacheKeyBuilder
        )

        try TimeProfiler.measure("Prepare and build patched project if needed") {
            let patchedProjectBuilder = createPatchedProjectBuilder(
                targetInfoFilter: targetInfoFilter,
                cacheStorage: cacheStorage,
                checksumProducer: checksumProducer,
                artifactIntegrator: artifactIntegrator
            )
            try patchedProjectBuilder.prepareAndBuildPatchedProjectIfNeeded(
                params: params,
                requiredTargets: requiredTargets
            )
        }
        
        let targetInfosForIntegration = targetInfoFilter.frameworkTargetInfos(requiredTargets)
        let integrated = try TimeProfiler.measure("Integrate artifacts to Derived Data") {
            try artifactIntegrator.integrateArtifacts(
                checksumProducer: checksumProducer,
                cacheStorage: cacheStorage,
                targetInfos: targetInfosForIntegration,
                to: params.configurationBuildDirectory
            )
        }
        
        try TimeProfiler.measure("Patch dSYM") {
            let dsymPatcher = createDSYMPatcher()
            try dsymPatcher.patchDSYM(
                for: integrated,
                sourcePath: sourcePath
            )
        }
        
    }
    
    private func createDSYMPatcher() -> DSYMPatcher {
        let symbolizer = createDSYMSymbolizer()
        let binaryPathProvider = BinaryPathProvider(fileManager: fileManager)
        let dsymPatcher = DSYMPatcher(
            symbolizer: symbolizer,
            binaryPathProvider: binaryPathProvider
        )
        return dsymPatcher
    }
    
    private func createBuildTargetChecksumProvider(
        podsProjectPath: String,
        checksumProducer: BaseURLChecksumProducer)
        throws -> TargetInfoProvider<BaseChecksum>
    {
        let frameworkChecksumProviderFactory = TargetInfoProviderFactory(
            checksumProducer: checksumProducer
        )
        let frameworkChecksumProvider = try frameworkChecksumProviderFactory.targetChecksumProvider(
            projectPath: podsProjectPath
        )
        return frameworkChecksumProvider
    }
    
    private func createDSYMSymbolizer() -> DSYMSymbolizer {
        let symbolizer = DSYMSymbolizer(
            symbolTableProvider: SymbolTableProviderImpl(shellCommandExecutor: shellCommandExecutor),
            dwarfUUIDProvider: DWARFUUIDProviderImpl(shellCommandExecutor: shellCommandExecutor),
            fileManager: fileManager
        )
        return symbolizer
    }
    
    private func createPatchedProjectBuilder(
        targetInfoFilter: TargetInfoFilter,
        cacheStorage: DefaultMixedFrameworkCacheStorage,
        checksumProducer: BaseURLChecksumProducer,
        artifactIntegrator: ArtifactIntegrator)
        -> PatchedProjectBuilder
    {
        let artifactProvider = TargetBuildArtifactProvider(
            fileManager: fileManager
        )
        let builder = XcodeProjectBuilder(
            shellExecutor: shellCommandExecutor
        )
        let patcher = XcodeProjectPatcher()
        return PatchedProjectBuilder(
            cacheStorage: cacheStorage,
            checksumProducer: checksumProducer,
            cacheKeyBuilder: cacheKeyBuilder,
            patcher: patcher,
            builder: builder,
            artifactIntegrator: artifactIntegrator,
            targetInfoFilter: targetInfoFilter,
            artifactProvider: artifactProvider
        )
    }
    
    private func createCacheStorage() throws -> DefaultMixedFrameworkCacheStorage {
        let localCacheDirectoryPath = fileManager.calciferDirectory()
            .appendingPathComponent("localCache")
        let localStorage = LocalBuildProductCacheStorage<BaseChecksum>(
            fileManager: fileManager,
            cacheDirectoryPath: localCacheDirectoryPath
        )
        let gradleHost = "http://gradle-remote-cache-ios.k.avito.ru"
        guard let gradleHostURL = URL(string: gradleHost) else {
            throw RemoteCachePreparerError.unableToCreateRemoteCacheHostURL(
                string: gradleHost
            )
        }
        let gradleClient = GradleBuildCacheClientImpl(
            gradleHost: gradleHostURL,
            session: URLSession.shared
        )
        let remoteStorage = GradleRemoteBuildProductCacheStorage<BaseChecksum>(
            gradleBuildCacheClient: gradleClient,
            fileManager: fileManager
        )
        return DefaultMixedFrameworkCacheStorage(
            fileManager: fileManager,
            localCacheStorage: localStorage,
            remoteCacheStorage: remoteStorage,
            shouldUpload: true
        )
    }
    
}
