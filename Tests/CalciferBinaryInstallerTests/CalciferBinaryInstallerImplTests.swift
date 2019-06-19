import Foundation
import XCTest
import Toolkit
import Mock
import LaunchdManager
@testable import CalciferBinaryInstaller

public final class CalciferBinaryInstallerImplTests: XCTestCase {
    
    func test_install() {
        // Given
        let fileManager = FileManager.default
        let calciferPathProvider = CalciferPathProviderImpl(fileManager: fileManager)
        let calciferBinaryName = calciferPathProvider.calciferBinaryName()
        let binaryPath = fileManager.temporaryDirectory
            .appendingPathComponent(UUID().uuidString)
            .appendingPathComponent(calciferBinaryName).path
        XCTAssertNoThrow(
            try fileManager.createDirectory(
                atPath: binaryPath.deletingLastPathComponent(),
                withIntermediateDirectories: true
            )
        )
        fileManager.createFile(
            atPath: binaryPath,
            contents: Data()
        )
        let destinationPath = fileManager.temporaryDirectory
            .appendingPathComponent(UUID().uuidString)
            .appendingPathComponent(calciferBinaryName).path
        let launchdManager = LaunchdManagerStub()
        let standardOutPath = fileManager.temporaryDirectory
            .appendingPathComponent(UUID().uuidString).path
        let standardErrorPath = fileManager.temporaryDirectory
            .appendingPathComponent(UUID().uuidString).path
        let plist = LaunchdPlist.daemonPlist(
            programPath: destinationPath,
            standardOutPath: standardOutPath,
            standardErrorPath: standardErrorPath
        )
        let plistPath = calciferPathProvider.launchAgentPlistPath(label: plist.label)
        var unloadPlistPath: String?
        launchdManager.onUnloadPlist = { _, plistPath in
            unloadPlistPath = plistPath
        }
        var loadPlistPath: String?
        launchdManager.onLoadPlist = { _, plistPath in
            // check order
            XCTAssertNotNil(unloadPlistPath)
            loadPlistPath = plistPath
        }
        let installer = CalciferBinaryInstallerImpl(
            fileManager: fileManager,
            launchdManager: launchdManager
        )
        // When
        XCTAssertNoThrow(
            try installer.install(
                binaryPath: binaryPath,
                destinationBinaryPath: destinationPath,
                plist: plist,
                plistPath: plistPath
            )
        )
        // Then
        XCTAssertEqual(unloadPlistPath, plistPath)
        XCTAssertEqual(loadPlistPath, plistPath)
    }
    
}
