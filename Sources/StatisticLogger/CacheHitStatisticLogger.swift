import Foundation
import XcodeBuildEnvironmentParametersParser

public protocol CacheHitStatisticLogger {
    func logStatisticCache(
        _ statistic: CacheHitRationStatistic,
        params: XcodeBuildEnvironmentParameters
    ) throws
}
