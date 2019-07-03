import Foundation
import XcodeProjCache
import Checksum
import Toolkit

public final class TargetInfoProviderFactory<ChecksumProducer: URLChecksumProducer> {
    
    private let checksumProducer: ChecksumProducer
    private let xcodeProjCache: XcodeProjCache
    private let factory: XcodeProjChecksumHolderBuilderFactory
    
    public init(
        checksumProducer: ChecksumProducer,
        xcodeProjCache: XcodeProjCache)
    {
        self.checksumProducer = checksumProducer
        self.xcodeProjCache = xcodeProjCache
        self.factory = XcodeProjChecksumHolderBuilderFactory(
            fullPathProvider: BaseFileElementFullPathProvider(),
            xcodeProjCache: xcodeProjCache
        )
    }
    
    public func targetChecksumProvider(
        projectPath: String,
        smartCalculate: Bool = true)
        throws -> TargetInfoProvider<ChecksumProducer.ChecksumType>
    {
        let builder = factory.projChecksumHolderBuilder(
            checksumProducer: checksumProducer
        )
        let xcodeProj = try TimeProfiler.measure("Obtain XcodeProj") {
            try xcodeProjCache.obtainXcodeProj(projectPath: projectPath)
        }
        let checksumHolder = try TimeProfiler.measure("Build checksum holders") {
            try builder.build(xcodeProj: xcodeProj, projectPath: projectPath)
        }
        let checksum: ChecksumProducer.ChecksumType = try TimeProfiler.measure("Obtain checksum") {
            if smartCalculate {
                return try checksumHolder.smartCalculate(checksumProducer: checksumProducer)
            } else {
                return try checksumHolder.obtainChecksum(checksumProducer: checksumProducer)
            }
        }
        Logger.info("XcodeProj checksum: \(checksum.stringValue) for \(checksumHolder.description)")
        let provider = TargetInfoProvider(
            checksumHolder: checksumHolder
        )
        return provider
    }
    
}
