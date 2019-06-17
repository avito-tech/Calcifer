import Foundation
import XCTest
import Toolkit
import Mock
import ShellCommand
@testable import LaunchdManager

public final class LaunchdManagerImplTests: XCTestCase {
    
    let fileManager = FileManager.default
    
    func test_unload() {
        // Given
        let plistPath = UUID().uuidString
        let shellCommandExecutor = ShellCommandExecutorStub() { command in
            XCTFail(
                "Incorrect command launchPath \(command.launchPath) or arguments \(command.arguments)"
            )
        }
        shellCommandExecutor.stubCommand(
            LaunchctlShellCommand(
                plistPath: plistPath,
                type: .unload
            )
        )
        let manager = LaunchdManagerImpl(
            fileManager: fileManager,
            shellExecutor: shellCommandExecutor
        )
        
        // When
        XCTAssertNoThrow(try manager.unloadPlistFromLaunchctl(plistPath: plistPath))
    }
    
    func test_load() {
        // Given
        let programPath = UUID().uuidString
        let standardOutPath = fileManager.temporaryDirectory
            .appendingPathComponent(UUID().uuidString).path
        let standardErrorPath = fileManager.temporaryDirectory
            .appendingPathComponent(UUID().uuidString).path
        let plist = LaunchdPlist.daemonPlist(
            programPath: programPath,
            standardOutPath: standardOutPath,
            standardErrorPath: standardErrorPath)
        let plistPath = fileManager.temporaryDirectory
            .appendingPathComponent(UUID().uuidString)
            .appendingPathComponent(plist.label)
            .appendingPathExtension("plist").path
        let shellCommandExecutor = ShellCommandExecutorStub() { command in
            XCTFail(
                "Incorrect command launchPath \(command.launchPath) or arguments \(command.arguments)"
            )
        }
        shellCommandExecutor.stubCommand(
            [
                ShellCommandStub(
                    LaunchctlShellCommand(
                        plistPath: plistPath,
                        type: .unload
                    )
                ),
                ShellCommandStub(
                    LaunchctlShellCommand(
                        plistPath: plistPath,
                        type: .load
                    )
                )
            ]
        )
        let manager = LaunchdManagerImpl(
            fileManager: fileManager,
            shellExecutor: shellCommandExecutor
        )
        
        // When
        XCTAssertNoThrow(
            try manager.loadPlistToLaunchctl(
                plist: plist,
                plistPath: plistPath
            )
        )

        // Then
        XCTAssertTrue(fileManager.fileExists(atPath: plistPath))
        XCTAssertNoThrow(try fileManager.removeItem(atPath: plistPath))
    }
    
}
