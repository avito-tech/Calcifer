import Foundation
import XCTest
import Toolkit
@testable import CalciferConfig

public final class CalciferConfigProviderTests: XCTestCase {
    
    let fileManager = FileManager.default
    
    func test_obtainDefaultConfig() {
        // Given
        let calciferDirectory = fileManager.temporaryDirectory
            .appendingPathComponent(UUID().uuidString).path
        let provider = CalciferConfigProvider(calciferDirectory: calciferDirectory)
        
        let projectDirectoryPath = fileManager.temporaryDirectory
            .appendingPathComponent(UUID().uuidString).path
        
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
        let calciferDirectory = fileManager.temporaryDirectory
            .appendingPathComponent(UUID().uuidString).path
        let provider = CalciferConfigProvider(calciferDirectory: calciferDirectory)
        
        let projectDirectoryPath = fileManager.temporaryDirectory
            .appendingPathComponent(UUID().uuidString).path
        let configPath = projectDirectoryPath
            .appendingPathComponent("CalciferConfig.json")
        let expectedLocalCacheDirectory = UUID().uuidString
        try? fileManager.write(
            [
                "enabled": false,
                "storageConfig": [
                    "localCacheDirectory": expectedLocalCacheDirectory
                ]
            ],
            to: configPath
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
        let calciferDirectory = fileManager.temporaryDirectory
            .appendingPathComponent(UUID().uuidString).path
        let provider = CalciferConfigProvider(calciferDirectory: calciferDirectory)
        
        let projectDirectoryPath = fileManager.temporaryDirectory
            .appendingPathComponent(UUID().uuidString).path
        let configPath = projectDirectoryPath
            .appendingPathComponent("CalciferConfig.json")
        try? fileManager.write(
            [
                "enabled": false,
                "storageConfig": [
                    "localCacheDirectory": UUID().uuidString
                ]
            ],
            to: configPath
        )
        let localConfigPath = projectDirectoryPath
            .appendingPathComponent("CalciferConfig.local.json")
        let expectedLocalCacheDirectory = UUID().uuidString
        try? fileManager.write(
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
        let calciferDirectory = fileManager.temporaryDirectory
            .appendingPathComponent(UUID().uuidString).path
        let provider = CalciferConfigProvider(calciferDirectory: calciferDirectory)
        
        let projectDirectoryPath = fileManager.temporaryDirectory
            .appendingPathComponent(UUID().uuidString).path
        let configPath = projectDirectoryPath
            .appendingPathComponent("CalciferConfig.json")
        
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
        
        try? fileManager.write(
            [
                "calciferShipConfig": [
                    "basicAccessAuthentication": [
                        "login": login,
                        "password": password
                    ]
                ]
            ],
            to: configPath
        )
        let localConfigPath = projectDirectoryPath
            .appendingPathComponent("CalciferConfig.local.json")
        try? fileManager.write(
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
    
}
