import Foundation

public final class ShellCommandExecutorImpl: ShellCommandExecutor {
    
    public init() {}
    
    // Use ProcessController from Emcee
    public func execute(command: ShellCommand) -> ShellCommandResult {
        let task = Process()
        task.launchPath = command.launchPath
        task.arguments = command.arguments
        task.environment = command.environment
        
        let outputPipe = Pipe()
        let errorPipe = Pipe()

        task.standardOutput = outputPipe
        task.standardError = errorPipe
        
        task.launch()
        
        let output = outputPipe.output()
        let error = errorPipe.output()
        
        task.waitUntilExit()
        
        let result = ShellCommandResult(
            terminationStatus: task.terminationStatus,
            output: output,
            error: error
        )
        
        return result
    }
    
}

extension Pipe {
    func output() -> String? {
        let data = fileHandleForReading.readDataToEndOfFile()
        return String(data: data, encoding: .utf8)
    }
}
