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
        guard let checksumHolder = targetChecksumHolder({ $0.name == target }) else {
            throw XcodeProjectChecksumCalculatorError.emptyTargetChecksum(targetName: target)
        }
        return try checksumHolder.allDependencies.map({ targetChecksumHolder in
            let targeChecksum = try targetChecksumHolder.checksum + buildParametersChecksum
            return TargetInfo(
                targetName: targetChecksumHolder.name,
                productName: targetChecksumHolder.productName,
                productType: targetChecksumHolder.productType,
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
            targetName: checksumHolder.name,
            productName: checksumHolder.productName,
            productType: checksumHolder.productType,
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
