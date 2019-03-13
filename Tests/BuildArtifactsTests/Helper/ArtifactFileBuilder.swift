import Foundation
import Checksum
import XcodeProjectChecksumCalculator

final class ArtifactFileBuilder {
    @discardableResult
    func createArtifactFile(
        fileManager: FileManager,
        targetInfo: TargetInfo<BaseChecksum>,
        at path: String) throws -> String
    {
        let frameworkContainingFolderPath = obtainExpectedPath(for: targetInfo, at: path)
        let frameworkPath = frameworkContainingFolderPath.appendingPathComponent("\(targetInfo.targetName).framework")
        try fileManager.createDirectory(
            atPath: frameworkContainingFolderPath,
            withIntermediateDirectories: true
        )
        try fileManager.createDirectory(
            atPath: frameworkPath,
            withIntermediateDirectories: true
        )
        let binaryPath = frameworkPath.appendingPathComponent(targetInfo.targetName)
        fileManager.createFile(
            atPath: binaryPath,
            contents: Data(base64Encoded: UUID().uuidString)
        )
        let dSYMPath = frameworkContainingFolderPath.appendingPathComponent("\(targetInfo.targetName).framework.dSYM")
        try fileManager.createDirectory(
            atPath: dSYMPath,
            withIntermediateDirectories: true
        )
        return frameworkContainingFolderPath
    }
    
    private func obtainExpectedPath(
        for targetInfo: TargetInfo<BaseChecksum>,
        at path: String)
        -> String
    {
        return path.appendingPathComponent(targetInfo.targetName)
    }
}
