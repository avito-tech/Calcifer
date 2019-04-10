import Foundation
import XcodeProjectChecksumCalculator
import Checksum

final class BinaryPathProvider {
    
    private let fileManager: FileManager
    
    public init(fileManager: FileManager) {
        self.fileManager = fileManager
    }
    
    public func obtainBinaryPath(
        from productPath: String,
        targetInfo: TargetInfo<BaseChecksum>)
        throws -> String
    {
        var path = productPath
            .appendingPathComponent(targetInfo.productName.deletingPathExtension())
        if fileManager.fileExists(atPath: path) {
            return path
        }
        path = productPath
            .appendingPathComponent(productPath.lastPathComponent().deletingPathExtension())
        if fileManager.fileExists(atPath: path) {
            return path
        }
        path = productPath.appendingPathComponent(targetInfo.targetName)
        if fileManager.fileExists(atPath: path) {
            return path
        }
        throw RemoteCachePreparerError.unableToBinaryInFramework(
            path: path,
            productName: targetInfo.productName
        )
    }
}
