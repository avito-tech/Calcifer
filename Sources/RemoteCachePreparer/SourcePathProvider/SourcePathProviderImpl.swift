import Foundation
import ShellCommand

public final class SourcePathProviderImpl: SourcePathProvider {
    
    private let shellCommandExecutor: ShellCommandExecutor
    
    init(shellCommandExecutor: ShellCommandExecutor) {
        self.shellCommandExecutor = shellCommandExecutor
    }
    
    public func obtainSourcePath(podsRoot: String) throws -> String {
        let command = BaseShellCommand(
            launchPath: "/usr/bin/git",
            arguments: [
                "-C",
                "\(podsRoot)",
                "rev-parse",
                "--show-toplevel"
            ],
            environment: [:]
        )
        let result = shellCommandExecutor.execute(command: command)
        guard let output = result.output,
            result.terminationStatus == 0
            else
        {
            throw RemoteCachePreparerError.unableToObtainSourcePath
        }
        // Remove trailing new line
        return output.chop()
    }
    
}
