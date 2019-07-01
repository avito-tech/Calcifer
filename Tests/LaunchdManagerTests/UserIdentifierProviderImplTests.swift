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
        let shellCommandExecutor = ShellCommandExecutorStub { command in
            XCTFail(
                "Incorrect command launchPath \(command.launchPath) or arguments \(command.arguments)"
            )
        }
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
