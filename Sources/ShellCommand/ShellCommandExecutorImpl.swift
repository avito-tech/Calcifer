import Foundation

public final class PipeReader {
    
    let pipe: Pipe
    let lock = NSLock()
    private var allData = Data()
    
    public init(pipe: Pipe) {
        self.pipe = pipe
    }
    
    public func setup(onNewData: ((Data) -> ())?) {
        setupReadabilityHandler { [weak self] newData in
            guard let strongSelf = self else {
                return
            }
            strongSelf.lock.lock()
            strongSelf.allData.append(newData)
            strongSelf.lock.unlock()
            onNewData?(newData)
        }
    }
    
    public func output() -> String? {
        lock.lock()
        let string = String(data: allData, encoding: .utf8)
        lock.unlock()
        return string
    }
    
    private func setupReadabilityHandler(obtain: @escaping (Data) -> ()) {
        pipe.fileHandleForReading.readabilityHandler = { [weak self] handle in
            let data = handle.availableData
            if data.isEmpty {
                self?.pipe.fileHandleForReading.readabilityHandler = nil
            } else {
                obtain(data)
            }
        }
    }
}

public final class ShellCommandExecutorImpl: ShellCommandExecutor {
    
    public init() {}
    
    // Use ProcessController from Emcee
    public func execute(
        command: ShellCommand,
        onOutputData: ((Data) -> ())?,
        onErrorData: ((Data) -> ())?)
        -> ShellCommandResult
    {
        let task = createTask(for: command)
        
        let outputPipeReader = PipeReader(pipe: Pipe())
        outputPipeReader.setup(onNewData: onOutputData)
        let errorPipeReader = PipeReader(pipe: Pipe())
        errorPipeReader.setup(onNewData: onErrorData)

        task.standardOutput = outputPipeReader.pipe
        task.standardError = errorPipeReader.pipe
        
        task.launch()
        
        task.waitUntilExit()
        
        let output = outputPipeReader.output()
        let error = errorPipeReader.output()
        
        let result = ShellCommandResult(
            terminationStatus: task.terminationStatus,
            output: output,
            error: error
        )
        
        return result
    }
    
    private func createTask(for command: ShellCommand) -> Process {
        let task = Process()
        task.launchPath = command.launchPath
        task.arguments = command.arguments
        task.environment = command.environment
        return task
    }
    
}
