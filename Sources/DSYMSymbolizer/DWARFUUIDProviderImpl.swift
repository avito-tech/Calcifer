import Foundation
import ShellCommand
import Toolkit

public final class DWARFUUIDProviderImpl: DWARFUUIDProvider {

    private let shellCommandExecutor: ShellCommandExecutor
    
    public init(shellCommandExecutor: ShellCommandExecutor) {
        self.shellCommandExecutor = shellCommandExecutor
    }
    
    public func obtainDwarfUUIDs(path: String) throws -> [DWARFUUID] {
        let command = ShellCommand(
            launchPath: "/usr/bin/dwarfdump",
            arguments: [
                "--uuid",
                path
            ],
            environment: [:]
        )
        let result = shellCommandExecutor.execute(command: command)
        guard let output = result.output,
            result.terminationStatus == 0
            else
        {
            throw DSYMSymbolizerError.unableToObtainDWARFDumpUUID(
                path: path,
                code: result.terminationStatus,
                output: result.output,
                error: result.error
            )
        }
        // UUID: A867BB40-4976-379A-8583-8E824C5CAC98 (x86_64) /Users/user/.calcifer/localCache/Unbox/9d4fe28fbbba90398d230f46ea0210f1/Unbox.framework/Unbox
        // UUID: A867BB40-4976-379A-8583-8E824C5CAC98 (x86_64) /Users/user/.calcifer/localCache/Unbox/9d4fe28fbbba90398d230f46ea0210f1/Unbox.framework/Unbox
        let lines = output.components(separatedBy: "\n")
        let dwarfUUIDs: [DWARFUUID] = lines.compactMap { line in
            let outputComponents = line.split(separator: " ")
            if outputComponents.count >= 4 &&
                outputComponents[0] == "UUID:",
                let uuid = UUID(uuidString: String(outputComponents[1])) // check is valid UUID
            {
                let architecture = String(outputComponents[2]).chomp(1).chop()
                return DWARFUUID(uuid: uuid, architecture: architecture)
            }
            return nil
        }
        if dwarfUUIDs.count == 0 {
            throw DSYMSymbolizerError.unableToObtainDWARFDumpUUID(
                path: path,
                code: result.terminationStatus,
                output: result.output,
                error: result.error
            )
        }
        return dwarfUUIDs
    }
}
