import Foundation
import XCTest
import ShellCommand
import Mock
@testable import DSYMSymbolizer

public final class BuildSourcePathProviderImplTests: XCTestCase {
    
    func test_provider() {
        XCTAssertNoThrow(try {
            // Given
            let shellCommandExecutor = ShellCommandExecutorStub()
            let sourcePathDirectory = URL(
                fileURLWithPath: NSTemporaryDirectory()
            ).appendingPathComponent("a")
            .appendingPathComponent("Sources")
            let sourcePath = sourcePathDirectory.deletingLastPathComponent()
            try FileManager.default.createDirectory(
                atPath: sourcePathDirectory.path,
                withIntermediateDirectories: true
            )
            let expectedBuildSourcePath = "/b"
            let output = "0000000000000000 - 00 0000    SO \(expectedBuildSourcePath)/Sources/"
            shellCommandExecutor.stub = { command in
                return ShellCommandResult(
                    terminationStatus: 0,
                    output: output,
                    error: nil
                )
            }
            let symbolTableProvider = SymbolTableProviderImpl(
                shellCommandExecutor: shellCommandExecutor
            )
            let buildSourcePathProvider = BuildSourcePathProviderImpl(
                symbolTableProvider: symbolTableProvider,
                fileManager: FileManager.default
            )
            
            // When
            let buildSourcePath = try buildSourcePathProvider.obtainBuildSourcePath(
                sourcePath: sourcePath.path,
                binaryPath: ""
            )
            
            // Then
            XCTAssertEqual(buildSourcePath, expectedBuildSourcePath)
            try FileManager.default.removeItem(
                at: sourcePath
            )
        }(), "Caught exception")
    }
    
}
