import Foundation
import ShellCommand
import Toolkit

public final class XcodeCommandLineToolVersionProvider {
    
    private let shellExecutor: ShellCommandExecutor
    
    public init(shellExecutor: ShellCommandExecutor) {
        self.shellExecutor = shellExecutor
    }
    
    public func obtainXcodeCommandLineToolVersion() throws -> String {
        let command = ShellCommand(
            launchPath: "/usr/bin/xcodebuild",
            arguments: [
                "-version"
            ],
            environment: [:]
        )
        let result = shellExecutor.execute(command: command)
        let statusCode = result.terminationStatus
        if statusCode != 0 {
            throw XcodeProjectBuilderError.failedExecuteXcodebuild(
                status: statusCode,
                command: command.description
            )
        }
        // Xcode 10.1
        // Build version 10B61
        guard let version = result.output?.split(separator: "\n")
            .last?.split(separator: " ").last else {
                throw XcodeProjectBuilderError.failedParseCommandLineToolVersion(string: result.output)
        }
        return String(version)
    }
}
