import Foundation

public protocol ShellCommandExecutor {
    func execute(command: ShellCommand) -> Int32
}
