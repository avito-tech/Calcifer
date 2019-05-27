import Foundation
import ShellCommand

final class Daemonizer {
    
    private let fileManager: FileManager
    private let shellExecutor: ShellCommandExecutor
    
    init(
        fileManager: FileManager,
        shellExecutor: ShellCommandExecutor)
    {
        self.fileManager = fileManager
        self.shellExecutor = shellExecutor
    }
    
    func daemonize() {
        guard let programPath = ProcessInfo.processInfo.arguments.first else {
            return
        }
        let plistPath = createPlist(programPath: programPath)
        loadPlistToLaunchctl(plistPath: plistPath)
    }
    
    private func createPlist(programPath: String) -> String {
        let label = "ru.calcifer.app"
        let fileName = "\(label).plist"
        let plistPath = "\(fileManager.home())/Library/LaunchAgents/\(fileName)"
        let content : [String: Any] = [
            "Label": label,
            "ProgramArguments": [
                programPath,
                "startDaemon"
            ],
            "KeepAlive": true
        ]
        let dictionary = NSDictionary(dictionary: content)
        
        if fileManager.fileExists(atPath: plistPath) {
            let plistContent = NSDictionary(contentsOfFile: plistPath)
            if plistContent == dictionary {
                return plistPath
            }
        }
        dictionary.write(toFile: plistPath, atomically: true)
        return plistPath
    }
    
    private func loadPlistToLaunchctl(plistPath: String) {
        let unloadCommand = ShellCommand(
            launchPath: "/bin/launchctl",
            arguments: [
                "unload",
                plistPath
            ],
            environment: [:]
        )
        _ = shellExecutor.execute(command: unloadCommand)
        let loadCommand = ShellCommand(
            launchPath: "/bin/launchctl",
            arguments: [
                "load",
                plistPath
            ],
            environment: [:]
        )
        _ = shellExecutor.execute(command: loadCommand)
    }
}
