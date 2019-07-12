import Foundation
import ShellCommand
import XCTest

public final class ShellCommandExecutorStub: ShellCommandExecutor {

    public var stub: ((ShellCommand) -> (ShellCommandResult)) = { _ in
        ShellCommandResult(
            terminationStatus: 0,
            output: nil,
            error: nil
        )
    }
    
    public var onMismatch: (ShellCommand) -> () = { command in
        XCTFail(
            "Incorrect command launchPath \(command.launchPath) or arguments \(command.arguments)"
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
    
    public func stubCommand(
        _ command: ShellCommand,
        output: String? = nil,
        error: String? = nil)
    {
        stubCommand(
            ShellCommandStub(
                command,
                output: output,
                error: error
            )
        )
    }
    
    public func stubCommand(_ stub: ShellCommandStub) {
        stubCommand([stub])
    }
    
    public func stubCommand(_ stubs: [ShellCommandStub]) {
        stub = { [weak self] command in
            guard let stub = stubs.first(where: { stub in
                stub.launchPath == command.launchPath && stub.arguments == command.arguments
            }) else {
                self?.onMismatch(command)
                return ShellCommandResult(terminationStatus: 1)
            }
            
            return ShellCommandResult(
                terminationStatus: 0,
                output: stub.output,
                error: stub.error
            )
        }
    }
    
}
