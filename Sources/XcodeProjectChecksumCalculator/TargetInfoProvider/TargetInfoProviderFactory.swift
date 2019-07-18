import Foundation
import XcodeProjCache
import Checksum
import Toolkit

public final class TargetInfoProviderFactory {
    
    private let checksumProducer: BaseURLChecksumProducer
    private let xcodeProjChecksumCache: BaseXcodeProjChecksumCache
    private let xcodeProjCache: XcodeProjCache
    private let xcodeProjChecksumHolderBuilderFactory: XcodeProjChecksumHolderBuilderFactory
    private let checksumCalculator: ChecksumCalculator
    private let checksumHolderValidator: ChecksumHolderValidator
    
    public init(
        checksumProducer: BaseURLChecksumProducer,
        xcodeProjChecksumCache: BaseXcodeProjChecksumCache,
        xcodeProjCache: XcodeProjCache,
        xcodeProjChecksumHolderBuilderFactory: XcodeProjChecksumHolderBuilderFactory,
        checksumCalculator: ChecksumCalculator,
        checksumHolderValidator: ChecksumHolderValidator)
    {
        self.checksumProducer = checksumProducer
        self.xcodeProjChecksumCache = xcodeProjChecksumCache
        self.xcodeProjCache = xcodeProjCache
        self.xcodeProjChecksumHolderBuilderFactory = xcodeProjChecksumHolderBuilderFactory
        self.checksumCalculator = checksumCalculator
        self.checksumHolderValidator = checksumHolderValidator
    }
    
    public func targetChecksumProvider(
        projectPath: String,
        validateChecksumHolder: Bool)
        throws -> TargetInfoProvider<BaseChecksum>
    {
        let builder = xcodeProjChecksumHolderBuilderFactory.projChecksumHolderBuilder(
            checksumProducer: checksumProducer,
            xcodeProjChecksumCache: xcodeProjChecksumCache
        )
        let xcodeProj = try TimeProfiler.measure("Obtain XcodeProj") {
            try xcodeProjCache.obtainXcodeProj(projectPath: projectPath)
        }
        let checksumHolder = try TimeProfiler.measure("Build checksum holders") {
            try builder.build(xcodeProj: xcodeProj, projectPath: projectPath)
        }
        let checksum = try TimeProfiler.measure("Obtain checksum") {
            try checksumCalculator.calculate(rootHolder: checksumHolder)
        }
        if validateChecksumHolder {
            try TimeProfiler.measure("Validate checksum holder") {
                try checksumHolderValidator.validate(checksumHolder)
            }
        }
        Logger.info("XcodeProj checksum: \(checksum.stringValue) for \(checksumHolder.description)")
        let provider = TargetInfoProvider(
            checksumHolder: checksumHolder
        )
        return provider
    }
    
}
