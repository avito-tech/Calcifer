import Foundation
import Checksum

public typealias DefaultMixedFrameworkCacheStorage = MixedBuildProductCacheStorage<
    BaseChecksum,
    LocalBuildProductCacheStorage<BaseChecksum>,
    GradleRemoteBuildProductCacheStorage<BaseChecksum>>
