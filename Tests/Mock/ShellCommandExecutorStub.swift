import Foundation
import ShellCommand

public final class ShellCommandExecutorStub: ShellCommandExecutor {

    public var stub: ((ShellCommand) -> (ShellCommandResult)) = { _ in
        return ShellCommandResult(
            terminationStatus: 0,
            output: nil,
            error: nil
        )
    }
    
    public init() {}

    public func execute(
        command: ShellCommand,
        onOutputData: ((Data) -> ())?,
        onErrorData: ((Data) -> ())?)
        -> ShellCommandResult
    {
        return stub(command)
    }
    
}
