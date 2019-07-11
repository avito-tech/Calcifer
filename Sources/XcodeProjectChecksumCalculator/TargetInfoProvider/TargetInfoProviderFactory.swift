import Foundation
import XcodeProjCache
import Checksum
import Toolkit

public final class TargetInfoProviderFactory {
    
    private let checksumProducer: BaseURLChecksumProducer
    private let xcodeProjChecksumCache: BaseXcodeProjChecksumCache
    private let xcodeProjCache: XcodeProjCache
    private let xcodeProjChecksumHolderBuilderFactory: XcodeProjChecksumHolderBuilderFactory
    
    public init(
        checksumProducer: BaseURLChecksumProducer,
        xcodeProjChecksumCache: BaseXcodeProjChecksumCache,
        xcodeProjCache: XcodeProjCache,
        xcodeProjChecksumHolderBuilderFactory: XcodeProjChecksumHolderBuilderFactory)
    {
        self.checksumProducer = checksumProducer
        self.xcodeProjChecksumCache = xcodeProjChecksumCache
        self.xcodeProjCache = xcodeProjCache
        self.xcodeProjChecksumHolderBuilderFactory = xcodeProjChecksumHolderBuilderFactory
    }
    
    public func targetChecksumProvider(
        projectPath: String,
        smartCalculate: Bool = true)
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
        let checksum: BaseChecksum = try TimeProfiler.measure("Obtain checksum") {
            if smartCalculate {
                return try checksumHolder.smartChecksumCalculate()
            } else {
                return try checksumHolder.obtainChecksum()
            }
        }
        Logger.info("XcodeProj checksum: \(checksum.stringValue) for \(checksumHolder.description)")
        let provider = TargetInfoProvider(
            checksumHolder: checksumHolder
        )
        return provider
    }
    
}
