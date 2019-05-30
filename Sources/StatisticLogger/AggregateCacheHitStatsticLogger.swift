import Foundation
import XcodeBuildEnvironmentParametersParser

public final class AggregateCacheHitStatsticLogger: CacheHitStatisticLogger {
    
    private let loggers: [CacheHitStatisticLogger]
    
    public init(loggers: [CacheHitStatisticLogger]) {
        self.loggers = loggers
    }
    
    public func logStatisticCache(
        _ statistic: CacheHitStatistic,
        params: XcodeBuildEnvironmentParameters)
        throws
    {
        for logger in loggers {
            try logger.logStatisticCache(
                statistic,
                params: params
            )
        }
    }
    
}
