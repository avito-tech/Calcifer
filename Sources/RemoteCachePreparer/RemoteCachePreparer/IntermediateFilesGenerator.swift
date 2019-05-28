import Foundation
import XcodeBuildEnvironmentParametersParser
import XcodeProjectChecksumCalculator
import Checksum
import Toolkit

public protocol IntermediateFilesGenerator {
    func generateIntermediateFiles(
        params: XcodeBuildEnvironmentParameters,
        buildDirectoryPath: String,
        requiredTargets: [TargetInfo<BaseChecksum>]
    ) throws
}

public class IntermediateFilesGeneratorImpl: IntermediateFilesGenerator {
    
    private let fileManager: FileManager
    
    init(fileManager: FileManager) {
        self.fileManager = fileManager
    }
    
    public func generateIntermediateFiles(
        params: XcodeBuildEnvironmentParameters,
        buildDirectoryPath: String,
        requiredTargets: [TargetInfo<BaseChecksum>]) throws
    {
        for targetInfo in requiredTargets {
            let intermediateFolderName = params.patchedProjectPath
                .lastPathComponent()
                .deletingPathExtension() + ".build"
            let allProductHeadersFilePath = buildDirectoryPath
                .appendingPathComponent(intermediateFolderName )
                .appendingPathComponent("\(params.configuration)-\(params.platformName)")
                .appendingPathComponent(targetInfo.productName.deletingPathExtension() + ".build")
                .appendingPathComponent("all-product-headers.yaml")
            
            let content = [
                "{",
                "  'version': 0,",
                "  'case-sensitive': 'false',",
                "  'roots': []",
                "}"
            ].joined(separator: "\n")
            
            if fileManager.fileExists(atPath: allProductHeadersFilePath) {
                let stringSize = content.utf8.count
                // Reading the contents of a file is very slow (large files).
                if let fileSize = fileManager.fileSize(at: allProductHeadersFilePath),
                    fileSize == stringSize {
                    let currentContent = try String(contentsOfFile: allProductHeadersFilePath)
                    if currentContent == content {
                        continue
                    }
                } else {
                    try fileManager.removeItem(atPath: allProductHeadersFilePath)
                }
            }
            
            let directoryPath = allProductHeadersFilePath.deletingLastPathComponent()
            if fileManager.directoryExist(at: directoryPath) == false {
                try fileManager.createDirectory(
                    atPath: directoryPath,
                    withIntermediateDirectories: true
                )
            }
            fileManager.createFile(
                atPath: allProductHeadersFilePath,
                contents: Data(content.utf8)
            )
        }
    }
    
}
