import Foundation
import Checksum

public final class TargetChecksumProvider<ChecksumType: Checksum> {
    
    private let checksumHolder: XcodeProjChecksumHolder<ChecksumType>
    
    init(checksumHolder: XcodeProjChecksumHolder<ChecksumType>) {
        self.checksumHolder = checksumHolder
    }
    
    public func checksum(for productName: String, buildParametersChecksum: ChecksumType) throws -> ChecksumType {
        let checksumHolder = targetChecksumHolder { $0.productName == productName }
        guard let targetChecksum = checksumHolder?.checksum else {
            throw ProjectChecksumError.emptyProductChecksum(productName: productName)
        }
        return try targetChecksum + buildParametersChecksum
    }
    
    public func dependencies(for target: String) throws -> [String] {
        guard let checksumHolder = targetChecksumHolder({ $0.name == target }) else {
            throw ProjectChecksumError.emptyTargetChecksum(targetName: target)
        }
        return checksumHolder.allDependencies.map({ $0.name })
    }
    
    private func targetChecksumHolder(
        _ filter: (TargetChecksumHolder<ChecksumType>) -> (Bool)
        ) -> TargetChecksumHolder<ChecksumType>?
    {
        return targetChecksumHolders().first {
            return filter($0)
        }
    }
    
    private func targetChecksumHolders() -> [TargetChecksumHolder<ChecksumType>] {
        return checksumHolder.proj.projects.flatMap({ $0.targets })
    }
    
}
