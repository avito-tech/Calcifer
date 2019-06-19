import Foundation
import XcodeBuildEnvironmentParametersParser
import GraphiteClient
import Toolkit
import IO

public final class GraphiteCacheHitStatisticLogger: CacheHitStatisticLogger {

    private let client: GraphiteClient
    private let rootKey: [String]
    private let version = 1
    
    private struct MetricKeyParts {
        // short
        static let metricName = "remotecache"
        static let targetName = "targetName"
        static let measureName = "hitrate"
        // full
        static let platformNameKey = "platformName"
        static let swiftVersionKey = "swiftVersion"
        static let configurationKey = "configuration"
        static let architecturesKey = "architectures"
        
        enum MetricType: String {
            case short = "short"
            case full = "full"
        }
    }
    
    public init(client: GraphiteClient, rootKey: [String]) {
        self.client = client
        self.rootKey = rootKey
    }
    
    public func logStatisticCache(
        _ statistic: CacheHitRationStatistic,
        params: XcodeBuildEnvironmentParameters)
        throws
    {
        let hitValue = statistic.hitRate
        let timestamp = Date()
        
        let shortKey = shortMetricKey(for: params)
        try client.send(
            path: shortKey,
            value: hitValue,
            timestamp: timestamp
        )
        
        let fullKey = fullMetricKey(for: params)
        try client.send(
            path: fullKey,
            value: hitValue,
            timestamp: timestamp
        )
    }
    
    private func shortMetricKey(for params: XcodeBuildEnvironmentParameters) -> [String] {
        return rootKey +
        [
            "v\(version)",
            params.user,
            MetricKeyParts.metricName,
            MetricKeyParts.targetName,
            params.targetName,
            MetricKeyParts.MetricType.short.rawValue,
            MetricKeyParts.measureName
        ]
    }
    
    private func fullMetricKey(for params: XcodeBuildEnvironmentParameters) -> [String] {
        return rootKey +
            [
                "v\(version)",
                params.user,
                MetricKeyParts.metricName,
                MetricKeyParts.targetName,
                params.targetName,
                MetricKeyParts.MetricType.full.rawValue,
                MetricKeyParts.measureName,
                MetricKeyParts.platformNameKey,
                params.platformName,
                MetricKeyParts.swiftVersionKey
            ] + params.swiftVersion.split(separator: ".").map { String($0) } +
            [
                MetricKeyParts.configurationKey,
                params.configuration,
                MetricKeyParts.architecturesKey,
                params.architectures.split(separator: " ").joined(separator: "-")
            ]
    }
    
}
