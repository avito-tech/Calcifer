import Foundation
import Checksum

public final class BuildArtifactIntegrator {
    
    private let fileManager: FileManager
    private let checksumProducer: BaseURLChecksumProducer
    
    public init(
        fileManager: FileManager,
        checksumProducer: BaseURLChecksumProducer)
    {
        self.fileManager = fileManager
        self.checksumProducer = checksumProducer
    }
    
    @discardableResult
    public func integrate<ChecksumType: Checksum>(
        artifacts: [TargetBuildArtifact<ChecksumType>],
        to path: String) throws -> [TargetBuildArtifact<ChecksumType>]
    {
        var destinations = [TargetBuildArtifact<ChecksumType>]()
        try artifacts.forEach { artifact in
            
            let productCurrentURL = URL(fileURLWithPath: artifact.productPath)
            let productDestinationURL = obtainProductDestination(for: artifact, at: path)
            try integrate(at: productCurrentURL, to: productDestinationURL)
            
            let dsymCurrentURL = URL(fileURLWithPath: artifact.dsymPath)
            let dsymDestinationURL = obtainDSYMDestination(for: artifact, at: path)
            try integrate(at: dsymCurrentURL, to: dsymDestinationURL)

            destinations.append(
                TargetBuildArtifact(
                    targetInfo: artifact.targetInfo,
                    productPath: productDestinationURL.path,
                    dsymPath: dsymDestinationURL.path
                )
            )
        }
        return destinations
    }
    
    private func integrate(at path: URL, to destination: URL) throws {
        // Performance issue in this check
        if try compareArtifacts(path, destination) == false {
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
    }
    
    private func compareArtifacts(
        _ artifactPath: URL,
        _ artifactDestination: URL)
        throws -> Bool
    {
        if fileManager.fileExists(atPath: artifactDestination.path) == false {
            return false
        }
        let artifactChecksum = try checksumProducer.checksum(input: artifactPath)
        // We do not throw an exception if there is nothing along this path. Just overwrite. This is a valid case.
        guard let destinationChecksum = try? checksumProducer.checksum(input: artifactDestination) else {
            return false
        }
        return artifactChecksum == destinationChecksum
    }
    
    private func obtainProductDestination<ChecksumType: Checksum>(
        for artifact: TargetBuildArtifact<ChecksumType>,
        at path: String)
        -> URL
    {
        let path = path
            .appendingPathComponent(artifact.targetInfo.targetName)
            .appendingPathComponent(artifact.productPath.lastPathComponent())
        return URL(fileURLWithPath: path)
    }
    
    private func obtainDSYMDestination<ChecksumType: Checksum>(
        for artifact: TargetBuildArtifact<ChecksumType>,
        at path: String)
        -> URL
    {
        let path = path
            .appendingPathComponent(artifact.targetInfo.targetName)
            .appendingPathComponent(artifact.dsymPath.lastPathComponent())
        return URL(fileURLWithPath: path)
    }
    
}
