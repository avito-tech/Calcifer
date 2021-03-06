import Foundation
import Checksum
import Toolkit

public final class BuildArtifactIntegrator {
    
    private let fileManager: FileManager
    private let checksumProducer: BaseURLChecksumProducer
    private let targetBuildArtifactMetaInfoManager: TargetBuildArtifactMetaInfoManager
    
    public init(
        fileManager: FileManager,
        checksumProducer: BaseURLChecksumProducer,
        targetBuildArtifactMetaInfoManager: TargetBuildArtifactMetaInfoManager)
    {
        self.fileManager = fileManager
        self.checksumProducer = checksumProducer
        self.targetBuildArtifactMetaInfoManager = targetBuildArtifactMetaInfoManager
    }
    
    @discardableResult
    public func integrate(
        artifacts: [TargetBuildArtifact<BaseChecksum>],
        to path: String) throws -> [TargetBuildArtifact<BaseChecksum>]
    {
        let destinations = ThreadSafeDictionary<
            TargetBuildArtifact<BaseChecksum>,
            TargetBuildArtifact<BaseChecksum>
        >()
        try artifacts.enumerateObjects(options: .concurrent) { artifact, _ in

            let productCurrentURL = URL(fileURLWithPath: artifact.productPath)
            let productDestinationURL = obtainProductDestination(for: artifact, at: path)
            
            let checksum = artifact.targetInfo.checksum
            try integrate(
                at: productCurrentURL,
                to: productDestinationURL,
                checksum: checksum
            )
        
            let dsymCurrentURL = URL(fileURLWithPath: artifact.dsymPath)
            let dsymDestinationURL = obtainDSYMDestination(for: artifact, at: path)
            try integrate(
                at: dsymCurrentURL,
                to: dsymDestinationURL,
                checksum: checksum
            )

            let destination = TargetBuildArtifact(
                targetInfo: artifact.targetInfo,
                productPath: productDestinationURL.path,
                dsymPath: dsymDestinationURL.path
            )
        
            destinations.write(destination, for: artifact)
        }
        return destinations.values
    }
    
    private func integrate(
        at path: URL,
        to destination: URL,
        checksum: BaseChecksum)
        throws
    {
        // Performance issue in this check
        if try compareArtifacts(path, destination, checksum) == false {
            if fileManager.directoryExist(at: destination) {
                try fileManager.removeItem(at: destination)
            }
            let destinationFolderURL = destination.deletingLastPathComponent()
            if fileManager.directoryExist(at: destinationFolderURL) == false {
                try fileManager.createDirectory(
                    at: destinationFolderURL,
                    withIntermediateDirectories: true
                )
            }
            try fileManager.copyItem(
                at: path,
                to: destination
            )
        }
        let metaInfo = TargetBuildArtifactMetaInfo(
            checksum: checksum
        )
        try targetBuildArtifactMetaInfoManager.write(
            metaInfo: metaInfo,
            artifactURL: destination
        )
    }
    
    private func compareArtifacts(
        _ artifactPath: URL,
        _ artifactDestination: URL,
        _ checksum: BaseChecksum)
        throws -> Bool
    {
        if fileManager.fileExists(atPath: artifactDestination.path) == false {
            return false
        }
        
        let metaInfo = try? targetBuildArtifactMetaInfoManager.readMetaInfo(
            artifactURL: artifactDestination
        )
        if let metaInfo = metaInfo,
            metaInfo.checksum == checksum {
            return true
        }
        
        let artifactFiles = try fileManager.files(at: artifactPath.path)
        let metaInfoFileName = targetBuildArtifactMetaInfoManager.metaInfoFileName()
        var destinationFiles = try fileManager.files(at: artifactDestination.path)
            .filter { !$0.contains(metaInfoFileName) }
        
        // Filter patched dSYM plist
        if artifactDestination.lastPathComponent.contains(".dSYM") {
            destinationFiles = destinationFiles.filter({ path -> Bool in
                if path.contains("/Contents/Resources") {
                    return path.pathExtension() != "plist"
                }
                return true
            })
        }
        
        if destinationFiles.count != artifactFiles.count {
            return false
        }
        
        let destinationFilesDictionary = Dictionary(
            uniqueKeysWithValues: destinationFiles.map {
                ($0.relativePath(to: artifactDestination.path), $0)
            }
        )
        
        for artifactFile in artifactFiles {
            let artifactFileRelativePath = artifactFile.relativePath(to: artifactPath.path)
            guard let destinationFile = destinationFilesDictionary[artifactFileRelativePath]
                else { return false }
            let artifactFileSize = try fileManager.fileSize(at: artifactFile)
            let destinationFileSize = try fileManager.fileSize(at: artifactFile)
            if artifactFileSize != destinationFileSize {
                return false
            }
            let artifactFileURL = URL(fileURLWithPath: artifactFile)
            let destinationFileURL = URL(fileURLWithPath: destinationFile)
            let artifactFileData = try Data(contentsOf: artifactFileURL)
            let destinationFileData = try Data(contentsOf: destinationFileURL)
            if artifactFileData != destinationFileData {
                return false
            }
        }
        return true
    }
    
    private func obtainProductsDirectoryDestination(
        for artifact: TargetBuildArtifact<BaseChecksum>,
        at path: String)
        -> String
    {
        if case .framework = artifact.targetInfo.productType {
            return path.appendingPathComponent(artifact.targetInfo.targetName)
        } else {
            return path
        }
    }
    
    private func obtainProductDestination(
        for artifact: TargetBuildArtifact<BaseChecksum>,
        at path: String)
        -> URL
    {
        let artifactPath = obtainProductsDirectoryDestination(for: artifact, at: path)
            .appendingPathComponent(artifact.productPath.lastPathComponent())
        return URL(fileURLWithPath: artifactPath)
    }
    
    private func obtainDSYMDestination(
        for artifact: TargetBuildArtifact<BaseChecksum>,
        at path: String)
        -> URL
    {
        let artifactPath = obtainProductsDirectoryDestination(for: artifact, at: path)
            .appendingPathComponent(artifact.dsymPath.lastPathComponent())
        return URL(fileURLWithPath: artifactPath)
    }
    
}
