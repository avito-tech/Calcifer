import Foundation

public final class ShellCommandExecutorImpl: ShellCommandExecutor {
    
    public init() {}
    
    // Use ProcessController from Emcee
    public func execute(command: ShellCommand) -> Int32 {
        let task = Process()
        task.launchPath = command.launchPath
        task.arguments = command.arguments
        task.environment = command.environment
        task.launch()
        task.waitUntilExit()
        return task.terminationStatus
    }
    
}
