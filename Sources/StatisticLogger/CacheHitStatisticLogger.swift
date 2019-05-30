import Foundation
import XcodeBuildEnvironmentParametersParser

public protocol CacheHitStatisticLogger {
    func logStatisticCache(
        _ statistic: CacheHitStatistic,
        params: XcodeBuildEnvironmentParameters
    ) throws
}
