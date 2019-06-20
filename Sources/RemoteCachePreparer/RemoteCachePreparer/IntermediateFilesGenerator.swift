import Foundation
import XcodeBuildEnvironmentParametersParser
import XcodeProjectChecksumCalculator
import BuildArtifacts
import Checksum
import Toolkit

public protocol IntermediateFilesGenerator {
    func generateIntermediateFiles(
        for artifacts: [TargetBuildArtifact<BaseChecksum>],
        params: XcodeBuildEnvironmentParameters,
        buildDirectoryPath: String
    ) throws
}

public class IntermediateFilesGeneratorImpl: IntermediateFilesGenerator {
    
    private let fileManager: FileManager
    
    init(fileManager: FileManager) {
        self.fileManager = fileManager
    }
    
    public func generateIntermediateFiles(
        for artifacts: [TargetBuildArtifact<BaseChecksum>],
        params: XcodeBuildEnvironmentParameters,
        buildDirectoryPath: String) throws
    {
        for artifact in artifacts {
            let intermediateFolderName = params.patchedProjectPath
                .lastPathComponent()
                .deletingPathExtension() + ".build"
            let productName = artifact.targetInfo.productName.deletingPathExtension()
            let intermediateDirectory = buildDirectoryPath
                .appendingPathComponent(intermediateFolderName)
                .appendingPathComponent("\(params.configuration)-\(params.platformName)")
                .appendingPathComponent(productName + ".build")
            if fileManager.directoryExist(at: intermediateDirectory) == false {
                try fileManager.createDirectory(
                    atPath: intermediateDirectory,
                    withIntermediateDirectories: true
                )
            }
            try copyModuleMapFile(
                artifact: artifact,
                toDirectory: intermediateDirectory
            )
            try createAllProductHeadersFile(
                atDirectory: intermediateDirectory
            )
        }
    }
    
    private func copyModuleMapFile(
        artifact: TargetBuildArtifact<BaseChecksum>,
        toDirectory directory: String)
        throws
    {
        let moduleMapFileName = "module.modulemap"
        let moduleMapPath = artifact.productPath
            .appendingPathComponent("Modules")
            .appendingPathComponent(moduleMapFileName)
        let moduleMapDestination = directory
            .appendingPathComponent(moduleMapFileName)
        if fileManager.fileExists(atPath: moduleMapDestination) {
            return
        }
        if fileManager.fileExists(atPath: moduleMapPath) {
            try fileManager.copyItem(
                atPath: moduleMapPath,
                toPath: moduleMapDestination
            )
        }
    }
    
    private func createAllProductHeadersFile(atDirectory directory: String) throws {
        let allProductHeadersFilePath = directory
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
            let fileSize = try fileManager.fileSize(at: allProductHeadersFilePath)
            if fileSize == stringSize {
                let currentContent = try String(contentsOfFile: allProductHeadersFilePath)
                if currentContent == content {
                    return
                }
            } else {
                try fileManager.removeItem(atPath: allProductHeadersFilePath)
            }
        }
        
        fileManager.createFile(
            atPath: allProductHeadersFilePath,
            contents: Data(content.utf8)
        )
    }
    
}
