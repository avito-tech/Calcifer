import Foundation
import ShellCommand

public final class Unzip {
    
    let shellExecutor: ShellCommandExecutor
    
    public init(shellExecutor: ShellCommandExecutor = ShellCommandExecutorImpl()) {
        self.shellExecutor = shellExecutor
    }
    
    public func unzip(_ path: String, to destination: String) throws {
        print("Thread \(Thread.current)")
        
        let command = ShellCommand(
            launchPath: "/usr/bin/unzip",
            arguments: [
                "-q",
                path,
                "-d",
                destination
            ],
            environment: [:]
        )
        let result = shellExecutor.execute(command: command)
        
        print("Thread \(Thread.current)")
        
        if result.terminationStatus != 0 {
            throw BuildProductCacheStorageError.unableToUnzipFile(path: path)
        }
    }
    
}
