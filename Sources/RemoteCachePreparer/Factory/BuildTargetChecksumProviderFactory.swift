import Foundation
import XcodeProjectChecksumCalculator
import XcodeProjCache
import Checksum
import Toolkit

public protocol BuildTargetChecksumProviderFactory {
    func createBuildTargetChecksumProvider(podsProjectPath: String)
        throws -> TargetInfoProvider<BaseChecksum>
}

public class BuildTargetChecksumProviderFactoryImpl: BuildTargetChecksumProviderFactory {
    
    private let fileManager: FileManager
    private let checksumProducer: BaseURLChecksumProducer
    private let xcodeProjCache: XcodeProjCache
    
    private lazy var targetInfoProviderFactory: TargetInfoProviderFactory<BaseURLChecksumProducer> = {
        TargetInfoProviderFactory(
            checksumProducer: checksumProducer,
            xcodeProjCache: xcodeProjCache
        )
    }()
    
    public static let shared: BuildTargetChecksumProviderFactory = {
        let fileManager = FileManager.default
        let checksumProducer = BaseURLChecksumProducer(fileManager: fileManager)
        let xcodeProjCache = XcodeProjCacheImpl.shared
        return BuildTargetChecksumProviderFactoryImpl(
            fileManager: fileManager,
            checksumProducer: checksumProducer,
            xcodeProjCache: xcodeProjCache
        )
    }()
    
    private init(
        fileManager: FileManager,
        checksumProducer: BaseURLChecksumProducer,
        xcodeProjCache: XcodeProjCache)
    {
        self.fileManager = fileManager
        self.checksumProducer = checksumProducer
        self.xcodeProjCache = xcodeProjCache
    }
    
    public func createBuildTargetChecksumProvider(
        podsProjectPath: String)
        throws -> TargetInfoProvider<BaseChecksum>
    {
        let targetChecksumProvider = try targetInfoProviderFactory.targetChecksumProvider(
            projectPath: podsProjectPath
        )
        return targetChecksumProvider
    }
}
