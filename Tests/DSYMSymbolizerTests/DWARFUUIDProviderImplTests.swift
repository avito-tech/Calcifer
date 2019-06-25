import Foundation
import XCTest
import ShellCommand
import Mock
@testable import DSYMSymbolizer

public final class DWARFUUIDProviderImplTests: XCTestCase {
    
    func test_provider() {
        XCTAssertNoThrow(try {
            // Given
            let shellCommandExecutor = ShellCommandExecutorStub { command in
                XCTFail(
                    "Incorrect command launchPath \(command.launchPath) or arguments \(command.arguments)"
                )
            }
            let uuid = UUID().uuidString
            let architecture = "x86_64"
            let output = [
                "UUID: \(uuid) (\(architecture))",
                "/Users/a/.calcifer/localCache/Unbox/9d4f...10f1/Unbox.framework/Unbox"
            ].joined(separator: " ")
            shellCommandExecutor.stub = { command in
                ShellCommandResult(
                    terminationStatus: 0,
                    output: output,
                    error: nil
                )
            }
            let uuidProvider = DWARFUUIDProviderImpl(
                shellCommandExecutor: shellCommandExecutor
            )
            
            // When
            let uuids = try uuidProvider.obtainDwarfUUIDs(path: "path_to_binary")
            
            // Then
            XCTAssertEqual(uuids.first?.uuid.uuidString, uuid)
            XCTAssertEqual(uuids.first?.architecture, architecture)
        }(), "Caught exception")
    }

}
