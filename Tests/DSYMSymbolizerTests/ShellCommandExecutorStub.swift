import Foundation
import ShellCommand

final class ShellCommandExecutorStub: ShellCommandExecutor {
    
    public var stub: ((ShellCommand) -> (ShellCommandResult))?
    
    init() {}
    
    func execute(
        command: ShellCommand,
        onOutputData: ((Data) -> ())?,
        onErrorData: ((Data) -> ())?)
        -> ShellCommandResult
    {
        if let stub = self.stub {
            return stub(command)
        }
        return ShellCommandResult(
            terminationStatus: 0,
            output: nil,
            error: nil
        )
    }
    
    
}
