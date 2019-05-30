import Foundation
import ShellCommand
import Toolkit

public final class XcodeProjectBuilder {
    
    private let shellExecutor: ShellCommandExecutor
    private let fileManager: FileManager
    
    public init(
        shellExecutor: ShellCommandExecutor,
        fileManager: FileManager)
    {
        self.shellExecutor = shellExecutor
        self.fileManager = fileManager
    }
    
    public func build(config: XcodeProjectBuildConfig, environment: [String: String]) throws {
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
        let logFile = buildLogFile()
        fileManager.createFile(atPath: logFile.path, contents: nil)
        let fileHandle = FileHandle(forWritingAtPath: logFile.path)
        let result = shellExecutor.execute(
            command: command,
            onOutputData: { [fileHandle] data in
                ObservableStandardStream.shared.writeOutput(data)
                fileHandle?.write(data)
            },
            onErrorData: { [fileHandle] data in
                ObservableStandardStream.shared.writeError(data)
                fileHandle?.write(data)
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
    
    private func buildLogFile() -> URL {
        let fileManager = FileManager.default
        let logDirectory = fileManager.calciferDirectory()
            .appendingPathComponent("buildlogs")
        try? fileManager.createDirectory(
            atPath: logDirectory,
            withIntermediateDirectories: true
        )
        let logFilePath = logDirectory
            .appendingPathComponent(Date().string())
            .appending(".txt")
        let logFile = URL(fileURLWithPath: logFilePath)
        return logFile
    }
    
}
