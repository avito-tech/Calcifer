import Foundation
import XCTest
import Toolkit
@testable import CalciferConfig

public final class CalciferConfigProviderTests: XCTestCase {
    
    lazy var fileManager = FileManager.default
    lazy var calciferDirectory = fileManager.temporaryDirectory
        .appendingPathComponent(UUID().uuidString).path
    lazy var projectDirectoryPath = fileManager.temporaryDirectory
        .appendingPathComponent(UUID().uuidString).path
    lazy var provider = CalciferConfigProvider(calciferDirectory: calciferDirectory)
    lazy var globalConfigPath = calciferDirectory
        .appendingPathComponent("CalciferConfig.json")
    lazy var projectConfigPath = projectDirectoryPath
        .appendingPathComponent("CalciferConfig.json")
    lazy var localConfigPath = projectDirectoryPath
        .appendingPathComponent("CalciferConfig.local.json")
    
    
    func test_obtainDefaultConfig() {
        // Given
        
        // When
        guard let config = try? provider.obtainConfig(
            projectDirectoryPath: projectDirectoryPath
        ) else {
            XCTFail("Failed to obtain config")
            return
        }
        
        // Then
        XCTAssertEqual(config.enabled, true)
        XCTAssertEqual(
            config.storageConfig.localCacheDirectory,
            calciferDirectory.appendingPathComponent("localCache")
        )
    }
    
    func test_obtainConfig_partialOverride() {
        // Given
        let expectedLocalCacheDirectory = UUID().uuidString
        write(
            [
                "enabled": false,
                "storageConfig": [
                    "localCacheDirectory": expectedLocalCacheDirectory
                ]
            ],
            to: projectConfigPath
        )
        
        // When
        guard let config = try? provider.obtainConfig(
            projectDirectoryPath: projectDirectoryPath
        ) else {
            XCTFail("Failed to obtain config")
            return
        }
        
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
    
    func test_obtainConfig_overrideByLocalConfig() {
        // Given
        write(
            [
                "enabled": false,
                "storageConfig": [
                    "localCacheDirectory": UUID().uuidString
                ]
            ],
            to: projectConfigPath
        )
        let expectedLocalCacheDirectory = UUID().uuidString
        write(
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
        guard let config = try? provider.obtainConfig(
            projectDirectoryPath: projectDirectoryPath
        ) else {
            XCTFail("Failed to obtain config")
            return
        }
        
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
    
    func test_obtainConfig_appendToNotValid() {
        // Given
        let login = UUID().uuidString
        let password = UUID().uuidString
        guard let versionFileURL = URL(string: "https://some.ru/version.json"),
            let zipBinaryFileURL = URL(string: "https://some.ru/Calcifer.zip")
            else {
                XCTFail("Can't create url")
                return
        }
        
        let expectedShipConfig = CalciferShipConfig(
            versionFileURL: versionFileURL,
            zipBinaryFileURL: zipBinaryFileURL,
            basicAccessAuthentication: BasicAccessAuthentication(
                login: login,
                password: password
            )
        )
        write(
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
        write(
            [
                "calciferShipConfig": [
                    "versionFileURL": versionFileURL.absoluteString,
                    "zipBinaryFileURL": zipBinaryFileURL.absoluteString
                ]
            ],
            to: localConfigPath
        )
        
        // When
        XCTAssertNoThrow(try provider.obtainConfig(
            projectDirectoryPath: projectDirectoryPath
            ))
        guard let config = try? provider.obtainConfig(
            projectDirectoryPath: projectDirectoryPath
        ) else {
            XCTFail("Failed to obtain config")
            return
        }
        
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
    
    func test_obtainConfig_allConfigTypes() {
        // Given
        let login = UUID().uuidString
        let password = UUID().uuidString
        guard let versionFileURL = URL(string: "https://some.ru/version.json"),
            let zipBinaryFileURL = URL(string: "https://some.ru/Calcifer.zip")
            else {
                XCTFail("Can't create url")
                return
        }
        
        let expectedShipConfig = CalciferShipConfig(
            versionFileURL: versionFileURL,
            zipBinaryFileURL: zipBinaryFileURL,
            basicAccessAuthentication: BasicAccessAuthentication(
                login: login,
                password: password
            )
        )
        
        guard let graphiteHost = URL(string: "https://graphite.ru")
            else {
                XCTFail("Can't create url")
                return
        }
        let expectedGraphiteConfig: [String: Any] = [
            "host": graphiteHost,
            "port": 8080,
            "rootKey": "metric.name"
        ]
        write(
            [
                "statisticLoggerConfig": [
                    "graphiteConfig": expectedGraphiteConfig
                ]
            ],
            to: globalConfigPath
        )
        write(
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
        write(
            [
                "calciferShipConfig": [
                    "versionFileURL": versionFileURL.absoluteString,
                    "zipBinaryFileURL": zipBinaryFileURL.absoluteString
                ]
            ],
            to: localConfigPath
        )
        
        // When
        XCTAssertNoThrow(try provider.obtainConfig(
            projectDirectoryPath: projectDirectoryPath
            ))
        guard let config = try? provider.obtainConfig(
            projectDirectoryPath: projectDirectoryPath
            ) else {
                XCTFail("Failed to obtain config")
                return
        }
        
        // Then
        XCTAssertEqual(config.enabled, true)
        guard let graphiteConfig = config.statisticLoggerConfig?.graphiteConfig else {
            XCTFail("Failed obtain graphite config")
            return
        }
        XCTAssertEqual(
            graphiteConfig.toDictionary(),
            expectedGraphiteConfig
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
    
    public func write(_ content: [String: Any], to path: String) {
        XCTAssertNoThrow(try {
            try self.fileManager.createDirectory(
                atPath: path.deletingLastPathComponent(),
                withIntermediateDirectories: true
            )
            let data = try JSONSerialization.data(
                withJSONObject: content,
                options: .prettyPrinted
            )
            try data.write(to: URL(fileURLWithPath: path))
        }())
    }
    
}
