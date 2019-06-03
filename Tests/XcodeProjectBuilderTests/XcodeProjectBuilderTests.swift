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
            let architecture = Architecture.x86_64
            let config = XcodeProjectBuildConfig(
                platform: .simulator,
                architectures: [architecture],
                buildDirectoryPath: "/b",
                projectPath: "projectPath",
                targetName: "targetName",
                configurationName: "Debug",
                onlyActiveArchitecture: true
            )
            let outputHandler = XcodeProjectBuilderOutputHandlerStub()
            let build = XcodeProjectBuilder(
                shellExecutor: shellCommandExecutor,
                outputHandler: outputHandler
            )
            
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
                    "-project",
                    config.projectPath,
                    "-target",
                    config.targetName,
                    "-configuration",
                    config.configurationName,
                    "-sdk",
                    config.platform.rawValue,
                    "build",
                    "BUILD_DIR=\(config.buildDirectoryPath)",
                    "OBJROOT=\(config.buildDirectoryPath)",
                    "ONLY_ACTIVE_ARCH=\(config.onlyActiveArchitecture ? "YES" : "NO")",
                    "ARCHS=\(architecture.rawValue)"
                ]
            )
        }(), "Caught exception")
    }
    
}
