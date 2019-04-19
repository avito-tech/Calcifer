import Foundation
import ShellCommand

public final class XcodeProjectBuilder {
    
    let shellExecutor: ShellCommandExecutor
    
    public init(shellExecutor: ShellCommandExecutor) {
        self.shellExecutor = shellExecutor
    }
    
    public func build(config: XcodeProjectBuildConfig, environment: [String: String]) throws {
        let command = ShellCommand(
            launchPath: "/usr/bin/xcodebuild",
            arguments: [
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
            ],
            environment: environment
        )
        let result = shellExecutor.execute(
            command: command,
            onOutputData: { data in
                FileHandle.standardOutput.write(data)
            },
            onErrorData: { data in
                FileHandle.standardError.write(data)
            }
        )
        let statusCode = result.terminationStatus
        if statusCode != 0 {
            throw XcodeProjectBuilderError.failedExecuteXcodebuild(
                status: statusCode,
                command: command.description
            )
        }
    }
    
}
