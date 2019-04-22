import Foundation
import ShellCommand
import Toolkit

public final class SymbolTableProviderImpl: SymbolTableProvider {

    private let shellCommandExecutor: ShellCommandExecutor
    
    public init(shellCommandExecutor: ShellCommandExecutor) {
        self.shellCommandExecutor = shellCommandExecutor
    }
    
    public func obtainSymbolTable(binaryPath: String) throws -> [String] {
        let command = ShellCommand(
            launchPath: "/usr/bin/nm",
            arguments: [
                "--pa",
                binaryPath
            ],
            environment: [:]
        )
        let result = shellCommandExecutor.execute(command: command)
        if result.terminationStatus != 0 {
            throw DSYMSymbolizerError.unableToObtainSymbols(
                binaryPath: binaryPath,
                code: result.terminationStatus,
                output: result.output,
                error: result.error
            )
        }
        guard let output = result.output else {
            throw DSYMSymbolizerError.emptyOutputSymbols(
                binaryPath: binaryPath,
                output: result.output,
                error: result.error
            )
        }
        let lines = output.components(separatedBy: "\n")
        return lines
    }
}
