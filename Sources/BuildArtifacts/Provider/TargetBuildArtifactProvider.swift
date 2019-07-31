import Foundation
import XcodeProjectChecksumCalculator
import Checksum
import Toolkit

public final class TargetBuildArtifactProvider {
    
    private let fileManager: FileManager
    
    public init(fileManager: FileManager) {
        self.fileManager = fileManager
    }
    
    public func artifacts<ChecksumType: Checksum>(
        for targetInfos: [TargetInfo<ChecksumType>],
        at path: String,
        dSYMShouldExist: Bool)
        throws -> [TargetBuildArtifact<ChecksumType>]
    {
        return try targetInfos.map { targetInfo in
            let artifactPath = path.appendingPathComponent(targetInfo.targetName)
            if fileManager.directoryExist(at: artifactPath) == false {
                throw BuildArtifactsError.productDirectoryDoesntExist(
                    targetName: targetInfo.targetName,
                    path: path
                )
            }
            let productPath = try obtainProductPath(at: artifactPath, targetInfo: targetInfo)
            let dsymPath = dSYMShouldExist ?
                try obtainDSYMPath(at: artifactPath, targetInfo: targetInfo) :
                try? obtainDSYMPath(at: artifactPath, targetInfo: targetInfo)
            return TargetBuildArtifact(
                targetInfo: targetInfo,
                productPath: productPath,
                dsymPath: dsymPath
            )
        }
    }
    
    private func obtainProductPath<ChecksumType: Checksum>(
        at path: String,
        targetInfo: TargetInfo<ChecksumType>)
        throws -> String
    {
        let frameworkPath = path.appendingPathComponent(targetInfo.productName)
        if fileManager.directoryExist(at: frameworkPath) == false {
            throw BuildArtifactsError.productDoesntExist(
                productName: targetInfo.targetName,
                path: path
            )
        }
        return frameworkPath
    }
    
    private func obtainDSYMPath<ChecksumType: Checksum>(
        at path: String,
        targetInfo: TargetInfo<ChecksumType>)
        throws -> String
    {
        let dsymName = "\(targetInfo.productName).dSYM"
        let dsymPath = path.appendingPathComponent(dsymName)
        if fileManager.directoryExist(at: dsymPath) == false {
            throw BuildArtifactsError.dsymDoesntExist(
                productName: targetInfo.targetName,
                path: path
            )
        }
        return dsymPath
    }
    
}
