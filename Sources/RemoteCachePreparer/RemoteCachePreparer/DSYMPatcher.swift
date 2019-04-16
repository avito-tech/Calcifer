import Foundation
import DSYMSymbolizer
import BuildArtifacts
import Checksum
import Toolkit

final class DSYMPatcher {
    
    private let symbolizer: DSYMSymbolizer
    private let binaryPathProvider: BinaryPathProvider
    
    public init(
        symbolizer: DSYMSymbolizer,
        binaryPathProvider: BinaryPathProvider)
    {
        self.symbolizer = symbolizer
        self.binaryPathProvider = binaryPathProvider
    }
    
    public func patchDSYM(
        for artifacts: [TargetBuildArtifact<BaseChecksum>],
        sourcePath: String,
        fullProductName: String) throws
    {
        let artifactsArray = artifacts as NSArray
        var symbolizeError: Error?
        artifactsArray.enumerateObjects(options: .concurrent) { obj, key, stop in
            if let artifact = obj as? TargetBuildArtifact<BaseChecksum> {
                do {
                    let dsymPath = artifact.dsymPath
                    
                    let pathToBinaryInApp = try obtainPathToBinaryInApp(
                        artifact: artifact,
                        fullProductName: fullProductName
                    )
                    
                    try symbolizer.symbolize(
                        dsymPath: dsymPath,
                        sourcePath: sourcePath,
                        binaryPath: pathToBinaryInApp
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
