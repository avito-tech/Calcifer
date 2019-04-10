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
        sourcePath: String) throws
    {
        let artifactsArray = artifacts as NSArray
        var symbolizeError: Error?
        artifactsArray.enumerateObjects(options: .concurrent) { obj, key, stop in
            if let artifact = obj as? TargetBuildArtifact<BaseChecksum> {
                do {
                    let dsymPath = artifact.dsymPath
                    let binaryPath = try binaryPathProvider.obtainBinaryPath(
                        from: artifact.productPath,
                        targetInfo: artifact.targetInfo
                    )
                    try symbolizer.symbolize(
                        dsymPath: dsymPath,
                        sourcePath: sourcePath,
                        binaryPath: binaryPath
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
}
