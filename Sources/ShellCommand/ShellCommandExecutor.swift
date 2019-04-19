import Foundation

public protocol ShellCommandExecutor {
    func execute(
        command: ShellCommand,
        onOutputData: ((Data) -> ())?,
        onErrorData: ((Data) -> ())?)
        -> ShellCommandResult
}

public extension ShellCommandExecutor {
    func execute(command: ShellCommand) -> ShellCommandResult {
        return execute(
            command: command,
            onOutputData: nil,
            onErrorData: nil
        )
    }
}
