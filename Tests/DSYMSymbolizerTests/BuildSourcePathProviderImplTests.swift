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
                fileManager: FileManager.default
            )
            
            // When
            let buildSourcePath = try buildSourcePathProvider.obtainBuildSourcePath(
                sourcePath: sourcePath.path,
                binaryPath: binaryPath
            )
            
            // Then
            XCTAssertEqual(buildSourcePath, expectedBuildSourcePath)
            try FileManager.default.removeItem(
                at: sourcePath
            )
        }(), "Caught exception")
    }
    
}
