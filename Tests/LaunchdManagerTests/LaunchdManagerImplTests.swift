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
        let shellCommandExecutor = ShellCommandExecutorStub { command in
            XCTFail(
                "Incorrect command launchPath \(command.launchPath) or arguments \(command.arguments)"
            )
        }
        let plist = LaunchdPlist.daemonPlist(
            programPath: UUID().uuidString,
            standardOutPath: UUID().uuidString,
            standardErrorPath: UUID().uuidString
        )
        let userId = UUID().uuidString
        shellCommandExecutor.stubCommand(
            LaunchctlShellCommand(
                plist: plist,
                plistPath: plistPath,
                type: .unload,
                domain: .user(userId: userId)
            )
        )
        let userIdentifierProvider = UserIdentifierProviderStub(userId: userId)
        let manager = LaunchdManagerImpl(
            fileManager: fileManager,
            shellExecutor: shellCommandExecutor,
            userIdentifierProvider: userIdentifierProvider
        )
        
        // When
        XCTAssertNoThrow(
            try manager.unloadPlistFromLaunchctl(
                plist: plist,
                plistPath: plistPath
            )
        )
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
            standardErrorPath: standardErrorPath
        )
        let plistPath = fileManager.temporaryDirectory
            .appendingPathComponent(UUID().uuidString)
            .appendingPathComponent(plist.label)
            .appendingPathExtension("plist").path
        let shellCommandExecutor = ShellCommandExecutorStub { command in
            XCTFail(
                "Incorrect command launchPath \(command.launchPath) or arguments \(command.arguments)"
            )
        }
        let userId = UUID().uuidString
        shellCommandExecutor.stubCommand(
            [
                ShellCommandStub(
                    LaunchctlShellCommand(
                        plist: plist,
                        plistPath: plistPath,
                        type: .unload,
                        domain: .user(userId: userId)
                    )
                ),
                ShellCommandStub(
                    LaunchctlShellCommand(
                        plist: plist,
                        plistPath: plistPath,
                        type: .enable,
                        domain: .user(userId: userId)
                    )
                ),
                ShellCommandStub(
                    LaunchctlShellCommand(
                        plist: plist,
                        plistPath: plistPath,
                        type: .load,
                        domain: .user(userId: userId)
                    )
                )
            ]
        )
        
        let userIdentifierProvider = UserIdentifierProviderStub(userId: userId)
        let manager = LaunchdManagerImpl(
            fileManager: fileManager,
            shellExecutor: shellCommandExecutor,
            userIdentifierProvider: userIdentifierProvider
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
