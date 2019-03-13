import Foundation

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
        let statusCode = shellExecutor.execute(command: command)
        if statusCode != 0 {
            throw XcodeProjectBuilderError.failedExecuteXcodebuild(
                status: statusCode,
                command: command.description
            )
        }
    }
    
}