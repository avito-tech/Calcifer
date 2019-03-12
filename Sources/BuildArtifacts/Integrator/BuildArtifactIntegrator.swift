import Foundation
import Checksum

public final class BuildArtifactIntegrator {
    
    private let fileManager: FileManager
    
    public init(fileManager: FileManager) {
        self.fileManager = fileManager
    }
    
    public func integrate<ChecksumType: Checksum>(
        artifacts: [TargetBuildArtifact<ChecksumType>],
        to path: String) throws
    {
        try artifacts.forEach { artifact in
            let artifactDestination = obtainDestination(for: artifact, at: path)
            let artifactDestinationFolderURL = artifactDestination.deletingLastPathComponent()
            try fileManager.createDirectory(at: artifactDestinationFolderURL, withIntermediateDirectories: true)
            let artifactCurrentURL = URL(fileURLWithPath: artifact.path)
            try fileManager.copyItem(
                at: artifactCurrentURL,
                to: artifactDestination
            )
        }
    }
    
    private func obtainDestination<ChecksumType: Checksum>(
        for artifact: TargetBuildArtifact<ChecksumType>,
        at path: String)
        -> URL
    {
        return URL(
            fileURLWithPath: path.appendingPathComponent(
                artifact.targetInfo.targetName
            )
        )
    }
    
}
