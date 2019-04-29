import Foundation
import XCTest
import ShellCommand
import Toolkit
import Mock
@testable import XcodeProjectBuilder

public final class XcodeProjectBuilderTests: XCTestCase {
    
    func test_symbolizer() {
        XCTAssertNoThrow(try {
            // Given
            let shellCommandExecutor = ShellCommandExecutorStub()
            var shellCommand: ShellCommand?
            shellCommandExecutor.stub = { command in
                shellCommand = command
                return ShellCommandResult(
                    terminationStatus: 0,
                    output: nil,
                    error: nil
                )
            }
            let config = XcodeProjectBuildConfig(
                platform: .simulator,
                architecture: .x86_64,
                projectPath: "projectPath",
                targetName: "targetName",
                configurationName: "Debug",
                onlyActiveArchitecture: true
            )
            let build = XcodeProjectBuilder(shellExecutor: shellCommandExecutor)
            
            // When
            try build.build(config: config, environment: [:])
            
            // Then
            guard let command = shellCommand else {
                XCTFail("shellCommand is nil")
                return
            }
            XCTAssertEqual(
                command.launchPath,
                "/usr/bin/xcodebuild"
            )
            XCTAssertEqual(
                command.arguments,
                [
                    "ARCHS=\(config.architecture.rawValue)",
                    "ONLY_ACTIVE_ARCH=\(config.onlyActiveArchitecture ? "YES" : "NO")",
                    "-project",
                    config.projectPath,
                    "-target",
                    config.targetName,
                    "-configuration",
                    config.configurationName,
                    "-sdk",
                    config.platform.rawValue,
                    "build"
                ]
            )
        }(), "Caught exception")
    }
    
}
