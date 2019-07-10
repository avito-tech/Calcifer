import Foundation
import XcodeProjCache
import Checksum
import Toolkit

public final class TargetInfoProviderFactory {
    
    private let checksumProducer: BaseURLChecksumProducer
    private let xcodeProjChecksumCache = XcodeProjChecksumCacheImpl.shared
    private let xcodeProjCache: XcodeProjCache
    private let factory: XcodeProjChecksumHolderBuilderFactory
    
    public init(
        checksumProducer: BaseURLChecksumProducer,
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
        throws -> TargetInfoProvider<BaseChecksum>
    {
        let builder = factory.projChecksumHolderBuilder(
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
