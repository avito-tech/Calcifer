import Foundation
import Checksum

public final class TargetInfoProvider<ChecksumType: Checksum> {
    
    private let checksumHolder: XcodeProjChecksumHolder<ChecksumType>
    
    init(checksumHolder: XcodeProjChecksumHolder<ChecksumType>) {
        self.checksumHolder = checksumHolder
    }
    
    public func dependencies(
        for target: String,
        buildParametersChecksum: ChecksumType) throws -> [TargetInfo<ChecksumType>] {
        guard let checksumHolder = targetChecksumHolder({ $0.targetName == target }) else {
            throw XcodeProjectChecksumCalculatorError.emptyTargetChecksum(targetName: target)
        }
        return try checksumHolder.allFlatDependencies.map({ targetChecksumHolder in
            let targeChecksum = try targetChecksumHolder.checksum + buildParametersChecksum
            return TargetInfo(
                targetName: targetChecksumHolder.targetName,
                productName: targetChecksumHolder.productName,
                productType: targetChecksumHolder.productType,
                dependencies: checksumHolder.dependencies.map { $0.targetName },
                checksum: targeChecksum
            )
        })
    }
    
    public func targetInfo(
        for productName: String,
        buildParametersChecksum: ChecksumType)
        throws -> TargetInfo<ChecksumType>
    {
        guard let checksumHolder = targetChecksumHolder({ $0.productName == productName }) else {
            throw XcodeProjectChecksumCalculatorError.emptyProductChecksum(
                productName: productName
            )
        }
        let targeChecksum = try checksumHolder.checksum + buildParametersChecksum
        return TargetInfo(
            targetName: checksumHolder.targetName,
            productName: checksumHolder.productName,
            productType: checksumHolder.productType,
            dependencies: checksumHolder.dependencies.map { $0.targetName },
            checksum: targeChecksum
        )
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
