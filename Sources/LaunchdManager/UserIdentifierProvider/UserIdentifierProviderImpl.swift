import Foundation
import ShellCommand

public final class UserIdentifierProviderImpl: UserIdentifierProvider {

    private let shellExecutor: ShellCommandExecutor
    
    public init(shellExecutor: ShellCommandExecutor) {
        self.shellExecutor = shellExecutor
    }

    public func currentUserIdentifier() throws -> String {
        let command = BaseShellCommand(
            launchPath: "/usr/bin/id",
            arguments: [
                "-u"
            ],
            environment: [:]
        )
        let result = shellExecutor.execute(command: command)
        guard let output = result.output,
            result.terminationStatus == 0
            else { throw LaunchdManagerError.failedToReceiveUserIdentifier(error: result.error) }
        return output.chop()
    }
}
