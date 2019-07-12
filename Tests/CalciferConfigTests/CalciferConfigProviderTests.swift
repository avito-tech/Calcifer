import Foundation
import XCTest
import Toolkit
import Mock
@testable import CalciferConfig

public final class CalciferConfigProviderTests: BaseTestCase {
    
    private lazy var calciferDirectory = createTmpDirectory().path
    private lazy var projectDirectoryPath = createTmpDirectory().path
    private lazy var provider = CalciferConfigProvider(calciferDirectory: calciferDirectory)
    private lazy var globalConfigPath = calciferDirectory
        .appendingPathComponent("CalciferConfig.json")
    private lazy var projectConfigPath = projectDirectoryPath
        .appendingPathComponent("CalciferConfig.json")
    private lazy var localConfigPath = projectDirectoryPath
        .appendingPathComponent("CalciferConfig.local.json")
    
    func test_obtainDefaultConfig() {
        assertNoThrow {
            // Given
            
            // When
            let config = try provider.obtainConfig(
                projectDirectoryPath: projectDirectoryPath
            )
            
            // Then
            XCTAssertEqual(config.enabled, true)
            XCTAssertEqual(
                config.storageConfig.localCacheDirectory,
                calciferDirectory.appendingPathComponent("localCache")
            )
        }
    }
    
    func test_obtainConfig_partialOverride() {
        assertNoThrow {
            // Given
            let expectedLocalCacheDirectory = UUID().uuidString
            try write(
                [
                    "enabled": false,
                    "storageConfig": [
                        "localCacheDirectory": expectedLocalCacheDirectory
                    ]
                ],
                to: projectConfigPath
            )
            
            // When
            let config = try provider.obtainConfig(
                projectDirectoryPath: projectDirectoryPath
            )
            
            // Then
            XCTAssertEqual(config.enabled, false)
            XCTAssertEqual(
                config.storageConfig.localCacheDirectory,
                expectedLocalCacheDirectory
            )
            XCTAssertEqual(
                config.storageConfig.shouldUpload,
                false
            )
        }
    }
    
    func test_obtainConfig_overrideByLocalConfig() {
        assertNoThrow {
            // Given
            try write(
                [
                    "enabled": false,
                    "storageConfig": [
                        "localCacheDirectory": UUID().uuidString
                    ]
                ],
                to: projectConfigPath
            )
            let expectedLocalCacheDirectory = UUID().uuidString
            try write(
                [
                    "enabled": true,
                    "storageConfig": [
                        "localCacheDirectory": expectedLocalCacheDirectory,
                        "shouldUpload": true
                    ]
                ],
                to: localConfigPath
            )
            
            // When
            let config = try provider.obtainConfig(
                projectDirectoryPath: projectDirectoryPath
            )
            
            // Then
            XCTAssertEqual(config.enabled, true)
            XCTAssertEqual(
                config.storageConfig.localCacheDirectory,
                expectedLocalCacheDirectory
            )
            XCTAssertEqual(
                config.storageConfig.shouldUpload,
                true
            )
        }
    }
    
    func test_obtainConfig_appendToNotValid() {
        assertNoThrow {
            // Given
            let login = UUID().uuidString
            let password = UUID().uuidString
            let versionFileURL = url("https://some.ru/version.json")
            let zipBinaryFileURL = url("https://some.ru/Calcifer.zip")
            
            let expectedShipConfig = CalciferShipConfig(
                versionFileURL: versionFileURL,
                zipBinaryFileURL: zipBinaryFileURL,
                basicAccessAuthentication: BasicAccessAuthentication(
                    login: login,
                    password: password
                )
            )
            try write(
                [
                    "calciferShipConfig": [
                        "basicAccessAuthentication": [
                            "login": login,
                            "password": password
                        ]
                    ]
                ],
                to: projectConfigPath
            )
            try write(
                [
                    "calciferShipConfig": [
                        "versionFileURL": versionFileURL.absoluteString,
                        "zipBinaryFileURL": zipBinaryFileURL.absoluteString
                    ]
                ],
                to: localConfigPath
            )
            
            // When
            try provider.obtainConfig(
                projectDirectoryPath: projectDirectoryPath
            )
            let config = try provider.obtainConfig(
                projectDirectoryPath: projectDirectoryPath
            )
            
            // Then
            XCTAssertEqual(config.enabled, true)
            XCTAssertEqual(
                config.calciferShipConfig,
                expectedShipConfig
            )
            XCTAssertEqual(
                config.calciferShipConfig?.basicAccessAuthentication,
                expectedShipConfig.basicAccessAuthentication
            )
        }
    }
    
    func test_obtainConfig_allConfigTypes() {
        assertNoThrow {
            // Given
            let login = UUID().uuidString
            let password = UUID().uuidString
            let versionFileURL = url("https://some.ru/version.json")
            let zipBinaryFileURL = url("https://some.ru/Calcifer.zip")
            
            let expectedShipConfig = CalciferShipConfig(
                versionFileURL: versionFileURL,
                zipBinaryFileURL: zipBinaryFileURL,
                basicAccessAuthentication: BasicAccessAuthentication(
                    login: login,
                    password: password
                )
            )
            
            let graphiteHost = url("https://graphite.ru")
            let expectedGraphiteConfig: [String: Any] = [
                "host": graphiteHost.absoluteString,
                "port": 8080,
                "rootKey": "metric.name"
            ]
            try write(
                [
                    "statisticLoggerConfig": [
                        "graphiteConfig": expectedGraphiteConfig
                    ]
                ],
                to: globalConfigPath
            )
            try write(
                [
                    "calciferShipConfig": [
                        "basicAccessAuthentication": [
                            "login": login,
                            "password": password
                        ]
                    ]
                ],
                to: projectConfigPath
            )
            try write(
                [
                    "calciferShipConfig": [
                        "versionFileURL": versionFileURL.absoluteString,
                        "zipBinaryFileURL": zipBinaryFileURL.absoluteString
                    ]
                ],
                to: localConfigPath
            )
            
            // When
            try provider.obtainConfig(
                projectDirectoryPath: projectDirectoryPath
            )
            let config = try provider.obtainConfig(
                projectDirectoryPath: projectDirectoryPath
            )
            
            // Then
            XCTAssertEqual(config.enabled, true)
            guard let graphiteConfig = config.statisticLoggerConfig?.graphiteConfig else {
                XCTFail("Failed obtain graphite config")
                return
            }
            let graphiteConfigDictionary = try? graphiteConfig.toDictionary()
            XCTAssertEqual(
                graphiteConfigDictionary?["host"] as? String,
                expectedGraphiteConfig["host"] as? String
            )
            XCTAssertEqual(
                graphiteConfigDictionary?["port"] as? Int,
                expectedGraphiteConfig["port"]  as? Int
            )
            XCTAssertEqual(
                graphiteConfigDictionary?["rootKey"] as? String,
                expectedGraphiteConfig["rootKey"] as? String
            )
            XCTAssertEqual(
                config.calciferShipConfig,
                expectedShipConfig
            )
            XCTAssertEqual(
                config.calciferShipConfig?.basicAccessAuthentication,
                expectedShipConfig.basicAccessAuthentication
            )
        }
    }
    
    public func write(_ content: [String: Any], to path: String) throws {
        try fileManager.createDirectory(
            atPath: path.deletingLastPathComponent(),
            withIntermediateDirectories: true
        )
        let data = try JSONSerialization.data(
            withJSONObject: content,
            options: .prettyPrinted
        )
        try data.write(to: URL(fileURLWithPath: path))
    }
    
}
