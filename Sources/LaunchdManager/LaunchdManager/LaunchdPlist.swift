import Foundation

public struct LaunchdPlist {
    public let label: String
    public let programArguments: [String]
    public let keepAlive: Bool
    
    public static func daemonPlist(programPath: String) -> LaunchdPlist {
        return LaunchdPlist(
            label: "ru.calcifer.app",
            programArguments: [
                programPath,
                "startDaemon"
            ],
            keepAlive: true
        )
    }
    
    var content: [String: Any] {
        return [
            "Label": label,
            "ProgramArguments": programArguments,
            "KeepAlive": keepAlive
        ]
    }
}
