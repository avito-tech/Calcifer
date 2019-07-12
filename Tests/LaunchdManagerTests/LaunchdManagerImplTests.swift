import Foundation
import XCTest
import Toolkit
import Mock
import ShellCommand
@testable import LaunchdManager

public final class LaunchdManagerImplTests: BaseTestCase {
    
    func test_unload() {
        // Given
        let plistPath = UUID().uuidString
        let shellCommandExecutor = ShellCommandExecutorStub()
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
        assertNoThrow {
            try manager.unloadPlistFromLaunchctl(
                plist: plist,
                plistPath: plistPath
            )
        }
    }
    
    func test_load() {
        // Given
        let programPath = UUID().uuidString
        let standardOutPath = createTmpDirectory().path
        let standardErrorPath = createTmpDirectory().path
        let plist = LaunchdPlist.daemonPlist(
            programPath: programPath,
            standardOutPath: standardOutPath,
            standardErrorPath: standardErrorPath
        )
        let plistPath = createTmpFile("\(plist.label).plist").path
        let shellCommandExecutor = ShellCommandExecutorStub()
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
        assertNoThrow {
            try manager.loadPlistToLaunchctl(
                plist: plist,
                plistPath: plistPath
            )
        }

        // Then
        XCTAssertTrue(fileManager.fileExists(atPath: plistPath))
        XCTAssertNoThrow(try fileManager.removeItem(atPath: plistPath))
    }
    
}
