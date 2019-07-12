import Foundation
import XCTest
import Toolkit
import Mock
import ShellCommand
@testable import LaunchdManager

public final class UserIdentifierProviderImplTests: XCTestCase {
    
    let fileManager = FileManager.default
    
    func test_unload() {
        // Given
        let shellCommandExecutor = ShellCommandExecutorStub()
        let epectedUserId = UUID().uuidString
        shellCommandExecutor.stubCommand(
            BaseShellCommand(
                launchPath: "/usr/bin/id",
                arguments: ["-u"],
                environment: [:]
            ),
            output: "\(epectedUserId)\n"
        )
        let userIdentifierProviderImpl = UserIdentifierProviderImpl(
            shellExecutor: shellCommandExecutor
        )
        
        // When
        let userID = try? userIdentifierProviderImpl.currentUserIdentifier()
        
        // Then
        XCTAssertEqual(userID, epectedUserId)
    }
    
}
