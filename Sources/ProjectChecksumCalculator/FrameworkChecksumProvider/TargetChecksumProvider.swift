import Foundation
import Checksum

public final class TargetChecksumProvider<C: Checksum> {
    
    private let checksumHolder: XcodeProjChecksumHolder<C>
    
    init(checksumHolder: XcodeProjChecksumHolder<C>) {
        self.checksumHolder = checksumHolder
    }
    
    public func checksum(for productName: String, buildParametersChecksum: C) throws -> C {
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
    
    private func targetChecksumHolder(_ filter: (TargetChecksumHolder<C>) -> (Bool)) -> TargetChecksumHolder<C>? {
        return targetChecksumHolders().first {
            return filter($0)
        }
    }
    
    private func targetChecksumHolders() -> [TargetChecksumHolder<C>] {
        return checksumHolder.proj.projects.flatMap({ $0.targets })
    }
    
}
