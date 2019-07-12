import Foundation
import Checksum
import Toolkit

public final class TargetInfoProvider<ChecksumType: Checksum> {
    
    private let checksumHolder: XcodeProjChecksumHolder<ChecksumType>
    
    init(checksumHolder: XcodeProjChecksumHolder<ChecksumType>) {
        self.checksumHolder = checksumHolder
    }
    
    public func dependencies(
        for target: String,
        buildParametersChecksum: ChecksumType)
        throws -> [TargetInfo<ChecksumType>]
    {
        guard let checksumHolder = targetChecksumHolder({ $0.targetName == target }) else {
            throw XcodeProjectChecksumCalculatorError.emptyTargetChecksum(targetName: target)
        }
        let allFlatDependencies = checksumHolder.allFlatDependencies
        let result: [TargetInfo<ChecksumType>] = try allFlatDependencies.map({ targetChecksumHolder in
            let targetChecksum = try targetChecksumHolder.obtainChecksum()
            let agregateChecksum = try [
                targetChecksum,
                buildParametersChecksum
            ].aggregate()
            return TargetInfo(
                targetName: targetChecksumHolder.targetName,
                productName: targetChecksumHolder.productName,
                productType: targetChecksumHolder.productType,
                dependencies: targetChecksumHolder.dependencies.values.map { $0.targetName },
                checksum: agregateChecksum
            )
        })
        return result
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
        let targetChecksum = try checksumHolder.obtainChecksum()
        let agregateChecksum = try [
            targetChecksum,
            buildParametersChecksum
        ].aggregate()
        return TargetInfo(
            targetName: checksumHolder.targetName,
            productName: checksumHolder.productName,
            productType: checksumHolder.productType,
            dependencies: checksumHolder.dependencies.values.map { $0.targetName },
            checksum: agregateChecksum
        )
    }
    
    public func saveChecksum(to path: String) {
        DispatchQueue.main.async {
            TimeProfiler.measure("Save checksum to file") { [weak self] in
                try? self?.checksumHolder.node().save(to: path)
            }
        }
    }

    private func targetChecksumHolder(
        _ filter: (TargetChecksumHolder<ChecksumType>) -> (Bool)
        ) -> TargetChecksumHolder<ChecksumType>?
    {
        return targetChecksumHolders().first {
            filter($0)
        }
    }
    
    private func targetChecksumHolders() -> [TargetChecksumHolder<ChecksumType>] {
        let targets = checksumHolder.projs
            .compactMap { $0.value }
            .flatMap { $0.projects.values }
            .flatMap { $0.targets.values }
        return targets
    }
    
}
