import Foundation
import XCTest
import ShellCommand
import Mock
@testable import DSYMSymbolizer

public final class BuildSourcePathProviderImplTests: BaseTestCase {
    
    func test_provider() {
        XCTAssertNoThrow(try {
            // Given
            let shellCommandExecutor = ShellCommandExecutorStub()
            let sourcePathDirectory = createTmpDirectory("Sources")
            let sourcePath = sourcePathDirectory.deletingLastPathComponent()
            let binaryPath = UUID().uuidString
            let expectedBuildSourcePath = "/b"
            let output = "0000000000000000 - 00 0000    SO \(expectedBuildSourcePath)/Sources/"
            shellCommandExecutor.stubCommand(
                ShellCommandStub(
                    launchPath: "/usr/bin/nm",
                    arguments: [
                        "--pa",
                        binaryPath
                    ],
                    output: output
                )
            )
            let symbolTableProvider = SymbolTableProviderImpl(
                shellCommandExecutor: shellCommandExecutor
            )
            let buildSourcePathProvider = BuildSourcePathProviderImpl(
                symbolTableProvider: symbolTableProvider,
                fileManager: fileManager
            )
            
            // When
            let buildSourcePath = try buildSourcePathProvider.obtainBuildSourcePath(
                sourcePath: sourcePath.path,
                binaryPath: binaryPath
            )
            
            // Then
            XCTAssertEqual(buildSourcePath, expectedBuildSourcePath)
        }(), "Caught exception")
    }
    
}
