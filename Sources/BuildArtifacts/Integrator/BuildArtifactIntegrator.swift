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
        
            let dsymPath: String?
            if let artifactDsymPath = artifact.dsymPath {
                let dsymCurrentURL = URL(fileURLWithPath: artifactDsymPath)
                let dsymDestinationURL = obtainDSYMDestination(
                    for: artifact,
                    artifactDsymPath: artifactDsymPath,
                    at: path
                )
                try integrate(
                    at: dsymCurrentURL,
                    to: dsymDestinationURL,
                    checksum: checksum
                )
                dsymPath = dsymDestinationURL.path
            } else {
                dsymPath = nil
            }

            let destination = TargetBuildArtifact(
                targetInfo: artifact.targetInfo,
                productPath: productDestinationURL.path,
                dsymPath: dsymPath
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
        if artifactDestination.lastPathComponent.contains(".framework.dSYM") {
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
    
    private func obtainProductDestination(
        for artifact: TargetBuildArtifact<BaseChecksum>,
        at path: String)
        -> URL
    {
        let path = path
            .appendingPathComponent(artifact.targetInfo.targetName)
            .appendingPathComponent(artifact.productPath.lastPathComponent())
        return URL(fileURLWithPath: path)
    }
    
    private func obtainDSYMDestination(
        for artifact: TargetBuildArtifact<BaseChecksum>,
        artifactDsymPath: String,
        at path: String)
        -> URL
    {
        let path = path
            .appendingPathComponent(artifact.targetInfo.targetName)
            .appendingPathComponent(artifactDsymPath.lastPathComponent())
        return URL(fileURLWithPath: path)
    }
    
}
