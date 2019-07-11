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
    
    private let targetInfoProviderFactory: TargetInfoProviderFactory
    
    public init(targetInfoProviderFactory: TargetInfoProviderFactory) {
        self.targetInfoProviderFactory = targetInfoProviderFactory
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
