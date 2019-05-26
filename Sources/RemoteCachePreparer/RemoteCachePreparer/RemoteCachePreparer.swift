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
    private let shellCommandExecutor: ShellCommandExecutor
    private let buildTargetChecksumProviderFactory: BuildTargetChecksumProviderFactory
    private let requiredTargetsProvider: RequiredTargetsProvider
    private let cacheStorageFactory: CacheStorageFactory
    
    
    init(
        fileManager: FileManager,
        shellCommandExecutor: ShellCommandExecutor,
        buildTargetChecksumProviderFactory: BuildTargetChecksumProviderFactory,
        requiredTargetsProvider: RequiredTargetsProvider,
        cacheStorageFactory: CacheStorageFactory)
    {
        self.fileManager = fileManager
        self.shellCommandExecutor = shellCommandExecutor
        self.buildTargetChecksumProviderFactory = buildTargetChecksumProviderFactory
        self.requiredTargetsProvider = requiredTargetsProvider
        self.cacheStorageFactory = cacheStorageFactory
    }
    
    func prepare(
        params: XcodeBuildEnvironmentParameters,
        sourcePath: String)
        throws
    {
        let podsProjectPath = params.podsProjectPath
        
        let checksumProducer = BaseURLChecksumProducer(fileManager: fileManager)
        let paramsChecksum = try BuildParametersChecksumProducer().checksum(input: params)
        
        try params.save(to: buildEnvironmentParametersPath())
        
        // TODO: save xcodeproj as json and if hash of xml same use json instead xcodeproj
        let targetChecksumProvider = try TimeProfiler.measure("Calculate checksum") {
            try buildTargetChecksumProviderFactory.createBuildTargetChecksumProvider(
                podsProjectPath: podsProjectPath,
                checksumProducer: checksumProducer
            )
        }
        try targetChecksumProvider.saveChecksumToFile()
        
        let cacheStorage = try cacheStorageFactory.createMixedCacheStorage(
            shouldUploadCache: false
        )
        let targetInfoFilter = TargetInfoFilter(targetInfoProvider: targetChecksumProvider)
        
        let requiredTargets = try TimeProfiler.measure("Obtain required targets") {
            try requiredTargetsProvider.obtainRequiredTargets(
                params: params,
                targetInfoFilter: targetInfoFilter,
                buildParametersChecksum: paramsChecksum
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
        
        let buildDirectoryPath = obtainBuildDirectoryPath()

        try TimeProfiler.measure("Prepare and build patched project if needed") {
            let patchedProjectBuilder = createPatchedProjectBuilder(
                targetInfoFilter: targetInfoFilter,
                cacheStorage: cacheStorage,
                checksumProducer: checksumProducer,
                artifactIntegrator: artifactIntegrator
            )
            try patchedProjectBuilder.prepareAndBuildPatchedProjectIfNeeded(
                params: params,
                buildDirectoryPath: buildDirectoryPath,
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
                sourcePath: sourcePath,
                fullProductName: params.fullProductName
            )
        }
        
        let intermediateFilesGenerator = IntermediateFilesGeneratorImpl(
            fileManager: fileManager
        )
        try TimeProfiler.measure("Generate intermediate files") {
            let targetsForIntermediateFiles = targetInfoFilter.frameworkTargetInfos(
                requiredTargets
            )
            try intermediateFilesGenerator.generateIntermediateFiles(
                params: params,
                buildDirectoryPath: buildDirectoryPath,
                requiredTargets: targetsForIntermediateFiles
            )
        }
        
    }
    
    private func createDSYMPatcher() -> DSYMPatcher {
        let symbolizer = createDSYMSymbolizer()
        let binaryPathProvider = BinaryPathProvider(fileManager: fileManager)
        let symbolTableProvider = SymbolTableProviderImpl(
            shellCommandExecutor: shellCommandExecutor
        )
        let buildSourcePathProvider = BuildSourcePathProviderImpl(
            symbolTableProvider: symbolTableProvider,
            fileManager: fileManager
        )
        let dsymPatcher = DSYMPatcher(
            symbolizer: symbolizer,
            binaryPathProvider: binaryPathProvider,
            buildSourcePathProvider: buildSourcePathProvider
        )
        return dsymPatcher
    }
    
    private func createDSYMSymbolizer() -> DSYMSymbolizer {
        let dwarfUUIDProvider = DWARFUUIDProviderImpl(shellCommandExecutor: shellCommandExecutor)
        let symbolizer = DSYMSymbolizer(
            dwarfUUIDProvider: dwarfUUIDProvider,
            fileManager: fileManager
        )
        return symbolizer
    }
    
    private func createPatchedProjectBuilder(
        targetInfoFilter: TargetInfoFilter,
        cacheStorage: BuildProductCacheStorage,
        checksumProducer: BaseURLChecksumProducer,
        artifactIntegrator: ArtifactIntegrator)
        -> PatchedProjectBuilder
    {
        let artifactProvider = TargetBuildArtifactProvider(
            fileManager: fileManager
        )
        let builder = XcodeProjectBuilder(
            shellExecutor: shellCommandExecutor,
            fileManager: fileManager
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
    
    func buildEnvironmentParametersPath() -> String {
        return fileManager
            .calciferDirectory()
            .appendingPathComponent("calciferenv.json")
    }
    
    private func obtainBuildDirectoryPath() -> String {
        return "/Users/Shared/remote-cache-build-folder.noindex/"
    }
    
}
