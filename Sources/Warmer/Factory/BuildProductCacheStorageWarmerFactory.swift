import Foundation
import XcodeProjectChecksumCalculator
import RemoteCachePreparer
import CalciferConfig
import Checksum
import Toolkit

public final class BuildProductCacheStorageWarmerFactory {
    
    private let configProvider: CalciferConfigProvider
    private let requiredTargetsProvider: RequiredTargetsProvider
    private let calciferPathProvider: CalciferPathProvider
    private let cacheKeyBuilder: BuildProductCacheKeyBuilder
    private let targetInfoFilter: TargetInfoFilter
    private let cacheStorageFactory: CacheStorageFactory
    
    public init(
        configProvider: CalciferConfigProvider,
        requiredTargetsProvider: RequiredTargetsProvider,
        calciferPathProvider: CalciferPathProvider,
        cacheKeyBuilder: BuildProductCacheKeyBuilder,
        targetInfoFilter: TargetInfoFilter,
        cacheStorageFactory: CacheStorageFactory)
    {
        self.configProvider = configProvider
        self.requiredTargetsProvider = requiredTargetsProvider
        self.calciferPathProvider = calciferPathProvider
        self.cacheKeyBuilder = cacheKeyBuilder
        self.targetInfoFilter = targetInfoFilter
        self.cacheStorageFactory = cacheStorageFactory
    }
    
    public func build() -> BuildProductCacheStorageWarmer {
        return BuildProductCacheStorageWarmer(
            configProvider: configProvider,
            requiredTargetsProvider: requiredTargetsProvider,
            calciferPathProvider: calciferPathProvider,
            cacheKeyBuilder: cacheKeyBuilder,
            targetInfoFilter: targetInfoFilter,
            cacheStorageFactory: cacheStorageFactory
        )
    }
}
