import Foundation
import XcodeProjectChecksumCalculator
import Checksum
import Toolkit

public protocol BuildTargetChecksumProviderFactory {
    func createBuildTargetChecksumProvider(podsProjectPath: String)
        throws -> TargetInfoProvider<BaseChecksum>
}

public class BuildTargetChecksumProviderFactoryImpl: BuildTargetChecksumProviderFactory {
    
    private let fileManager: FileManager
    private let checksumProducer: BaseURLChecksumProducer
    
    private lazy var targetInfoProviderFactory: TargetInfoProviderFactory<BaseURLChecksumProducer> = {
        TargetInfoProviderFactory(
            checksumProducer: checksumProducer
        )
    }()
    
    public static let shared: BuildTargetChecksumProviderFactory = {
        let fileManager = FileManager.default
        let checksumProducer = BaseURLChecksumProducer(fileManager: fileManager)
        return BuildTargetChecksumProviderFactoryImpl(
            fileManager: fileManager,
            checksumProducer: checksumProducer
        )
    }()
    
    private init(
        fileManager: FileManager,
        checksumProducer: BaseURLChecksumProducer)
    {
        self.fileManager = fileManager
        self.checksumProducer = checksumProducer
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
