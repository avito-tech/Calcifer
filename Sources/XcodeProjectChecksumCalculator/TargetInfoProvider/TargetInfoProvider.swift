import Foundation
import Checksum
import Toolkit

public final class TargetInfoProvider<ChecksumType: Checksum> {
    
    private let checksumHolder: XcodeProjChecksumHolder<ChecksumType>
    
    init(checksumHolder: XcodeProjChecksumHolder<ChecksumType>) {
        self.checksumHolder = checksumHolder
    }
    
    public func dependencies<ChecksumProducer: URLChecksumProducer>(
        for target: String,
        checksumProducer: ChecksumProducer,
        buildParametersChecksum: ChecksumType)
        throws -> [TargetInfo<ChecksumType>]
        where ChecksumProducer.ChecksumType == ChecksumType
    {
        guard let checksumHolder = targetChecksumHolder({ $0.targetName == target }) else {
            throw XcodeProjectChecksumCalculatorError.emptyTargetChecksum(targetName: target)
        }
        let allFlatDependencies = checksumHolder.allFlatDependencies
        let result: [TargetInfo<ChecksumType>] = try allFlatDependencies.map({ targetChecksumHolder in
            let targetChecksum = try targetChecksumHolder.obtainChecksum(checksumProducer: checksumProducer)
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
    
    public func targetInfo<ChecksumProducer: URLChecksumProducer>(
        for productName: String,
        checksumProducer: ChecksumProducer,
        buildParametersChecksum: ChecksumType)
        throws -> TargetInfo<ChecksumType>
        where ChecksumProducer.ChecksumType == ChecksumType
    {
        guard let checksumHolder = targetChecksumHolder({ $0.productName == productName }) else {
            throw XcodeProjectChecksumCalculatorError.emptyProductChecksum(
                productName: productName
            )
        }
        let targetChecksum = try checksumHolder.obtainChecksum(checksumProducer: checksumProducer)
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
    
    public func saveChecksum(to path: String) throws {
        try TimeProfiler.measure("Save checksum to file") {
            let data = try checksumHolder.node().encode()
            let outputFileURL = URL(fileURLWithPath: path)
            try data.write(to: outputFileURL)
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
