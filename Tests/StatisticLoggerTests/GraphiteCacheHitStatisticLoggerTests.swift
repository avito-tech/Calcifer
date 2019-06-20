import Foundation
import XCTest
import Toolkit
import GraphiteClient
import IO
import Mock
import XcodeBuildEnvironmentParametersParser
@testable import StatisticLogger

public final class GraphiteCacheHitStatisticLoggerTests: XCTestCase {
    
    let outputStream = OutputStream(toMemory: ())
    
    lazy var easyOutputStream: EasyOutputStream = {
        let outputStreamProvider = CustomOutputStreamProvider(outputStream: outputStream)
        let easyOutputStream = EasyOutputStream(
            outputStreamProvider: outputStreamProvider,
            errorHandler: { _, _ in },
            streamEndHandler: { _ in }
        )
        try? easyOutputStream.open()
        return easyOutputStream
    }()
    
    lazy var client: GraphiteClient = {
        return GraphiteClient(easyOutputStream: easyOutputStream)
    }()
    
    let rootKey = "rootKey"
    let params = catchError { try XcodeBuildEnvironmentParameters.forTests() }
    
    lazy var logger: GraphiteCacheHitStatisticLogger = {
        return GraphiteCacheHitStatisticLogger(
            client: client,
            rootKey: [rootKey]
        )
    }()
    
    func test_logStatistic() {
        // Given
        let hitValues = (hit: Double(4), miss: Double(2))
        let statistic = generateStatistic(hitCount: Int(hitValues.hit), missCount: Int(hitValues.miss))
        
        // When
        XCTAssertNoThrow(try logger.logStatisticCache(statistic, params: params))
        // Then
        XCTAssertEqual(
            obtainMetric(),
            expectedMetric(hit: hitValues.hit, miss: hitValues.miss)
        )
    }
    
    func test_logStatistic_zeroBuild() {
        // Given
        let hitValues = (hit: Double(0), miss: Double(0))
        let statistic = generateStatistic(hitCount: Int(hitValues.hit), missCount: Int(hitValues.miss))
        // When
        XCTAssertNoThrow(try logger.logStatisticCache(statistic, params: params))
        // Then
        XCTAssertEqual(
            obtainMetric(),
            expectedMetric(hit: hitValues.hit, miss: hitValues.miss)
        )
    }
    
    func expectedMetric(hit: Double, miss: Double) -> String {
        guard hit != 0 && miss != 0 else { return "" }
        let expectedMetricKey = "\(rootKey).v1.\(params.user).remotecache.targetName.\(params.targetName).short.hitrate"
        let expectedMetricValue = "\(hit / (hit + miss))"
        return "\(expectedMetricKey) \(expectedMetricValue)"
    }
    
    private func obtainMetric() -> String {
        guard let data = outputStream.property(forKey: .dataWrittenToMemoryStreamKey) as? Data,
            let string = String(data: data, encoding: .utf8) else {
                XCTFail("Unable to read data from stream")
                return ""
        }
        let metricParts = string.split(separator: " ")
        if metricParts.count < 3 {
            return ""
        }
        let metricKey = metricParts[0]
        let metricValue = metricParts[1]
        return "\(metricKey) \(metricValue)"
    }
    
    private func generateStatistic(hitCount: Int, missCount: Int) -> CacheHitRationStatistic {
        var entries = [CacheHitRationEntry]()
        let appendToEntries: (CacheResolution) -> () = { resolution in
            entries.append(
                CacheHitRationEntry(
                    moduleName: UUID().uuidString,
                    resolution: resolution
                )
            )
        }
        for _ in 0..<hitCount {
            appendToEntries(.hit)
        }
        for _ in 0..<missCount {
            appendToEntries(.miss)
        }
        return CacheHitRationStatistic(
            entries: entries
        )
    }
    
}
