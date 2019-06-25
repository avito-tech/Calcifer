import Foundation
import DSYMSymbolizer
import BuildArtifacts
import Checksum
import Toolkit

public final class DSYMPatcher {
    
    private let symbolizer: DSYMSymbolizer
    private let binaryPathProvider: BinaryPathProvider
    private let buildSourcePathProvider: BuildSourcePathProvider
    private let artifactBuildSourcePathCache: ArtifactBuildSourcePathCache
    
    public init(
        symbolizer: DSYMSymbolizer,
        binaryPathProvider: BinaryPathProvider,
        buildSourcePathProvider: BuildSourcePathProvider,
        artifactBuildSourcePathCache: ArtifactBuildSourcePathCache)
    {
        self.symbolizer = symbolizer
        self.binaryPathProvider = binaryPathProvider
        self.buildSourcePathProvider = buildSourcePathProvider
        self.artifactBuildSourcePathCache = artifactBuildSourcePathCache
    }
    
    public func patchDSYM(
        for artifacts: [TargetBuildArtifact<BaseChecksum>],
        sourcePath: String,
        fullProductName: String) throws
    {
        let artifactsArray = artifacts as NSArray
        var symbolizeError: Error?
        artifactsArray.enumerateObjects(options: .concurrent) { obj, _, stop in
            if let artifact = obj as? TargetBuildArtifact<BaseChecksum> {
                do {
                    let dsymPath = artifact.dsymPath
                    
                    let shouldPatch = try symbolizer.shouldPatchDSYM(
                        dsymBundlePath: dsymPath,
                        sourcePath: sourcePath
                    )
                    
                    if shouldPatch == false {
                        return
                    }
                    
                    let pathToBinaryInApp = try obtainPathToBinaryInApp(
                        artifact: artifact,
                        fullProductName: fullProductName
                    )
                    
                    let binaryPath = binaryPathProvider.obtainBinaryPath(
                        from: artifact.productPath,
                        targetInfo: artifact.targetInfo
                    )
                    
                    let buildSourcePath = try obtainBuildSourcePath(
                        artifacts: artifact,
                        binaryPath: binaryPath,
                        sourcePath: sourcePath
                    )
                    
                    if buildSourcePath == sourcePath {
                        return
                    }
                    
                    Logger.verbose("Symbolize dSYM \(dsymPath) buildSourcePath \(buildSourcePath) sourcePath \(sourcePath) for \(pathToBinaryInApp)")
                    
                    try symbolizer.symbolize(
                        dsymBundlePath: dsymPath,
                        sourcePath: sourcePath,
                        buildSourcePath: buildSourcePath,
                        binaryPath: binaryPath,
                        binaryPathInApp: pathToBinaryInApp
                    )
                } catch {
                    symbolizeError = error
                    stop.pointee = true
                    return
                }
            }
        }
        if let error = symbolizeError {
            throw error
        }
    }
    
    private func obtainBuildSourcePath(
        artifacts: TargetBuildArtifact<BaseChecksum>,
        binaryPath: String,
        sourcePath: String)
        throws -> String
    {
        if let buildSourcePathCache = artifactBuildSourcePathCache.buildSourcePath(
            for: artifacts.targetInfo,
            sourcePath: sourcePath)
        {
            return buildSourcePathCache
        }
        let buildSourcePath = try buildSourcePathProvider.obtainBuildSourcePath(
            sourcePath: sourcePath,
            binaryPath: binaryPath
        )
        artifactBuildSourcePathCache.save(
            buildSourcePath: buildSourcePath,
            for: artifacts.targetInfo,
            sourcePath: sourcePath
        )
        return buildSourcePath
    }
    
    private func obtainPathToBinaryInApp(
        artifact: TargetBuildArtifact<BaseChecksum>,
        fullProductName: String)
        throws -> String {
        let appProductPath = artifact.productPath
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .appendingPathComponent(fullProductName)
        let frameworkName = artifact.productPath.lastPathComponent()
        let frameworkPath = appProductPath
            .appendingPathComponent("Frameworks")
            .appendingPathComponent(frameworkName)
        let binaryPath = binaryPathProvider.obtainBinaryPath(
            from: frameworkPath,
            targetInfo: artifact.targetInfo
        )
        return binaryPath
    }
}
