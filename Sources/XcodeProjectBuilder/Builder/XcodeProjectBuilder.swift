import Foundation
import ShellCommand
import Toolkit

public final class XcodeProjectBuilder {
    
    private let shellExecutor: ShellCommandExecutor
    private let outputHandler: XcodeProjectBuilderOutputHandler
    
    public init(
        shellExecutor: ShellCommandExecutor,
        outputHandler: XcodeProjectBuilderOutputHandler)
    {
        self.shellExecutor = shellExecutor
        self.outputHandler = outputHandler
    }
    
    public func build(
        config: XcodeProjectBuildConfig,
        environment: [String: String]) throws {
        let architectures = config.architectures.map { $0.rawValue }.joined(separator: " ")
        let onlyActiveArchitecture = config.onlyActiveArchitecture ? "YES" : "NO"
        let command = ShellCommand(
            launchPath: "/usr/bin/xcodebuild",
            arguments: [
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
                "ONLY_ACTIVE_ARCH=\(onlyActiveArchitecture)",
                "ARCHS=\(architectures)"
            ],
            environment: environment
        )
        Logger.verbose("Execute build command \(command.launchPath) \(command.arguments.joined(separator: " ")) with environment \(command.environment)")
        outputHandler.setupFileWrite()
        let result = shellExecutor.execute(
            command: command,
            onOutputData: { [outputHandler] data in
                outputHandler.writeOutput(data)
            },
            onErrorData: { [outputHandler] data in
                outputHandler.writeError(data)
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
