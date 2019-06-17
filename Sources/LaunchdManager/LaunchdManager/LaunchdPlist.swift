import Foundation

public struct LaunchdPlist {
    public let label: String
    public let programPath: String
    public let standardOutPath: String
    public let standardErrorPath: String
    
    private let programArguments: [String]
    private let keepAlive: Bool
    
    public static func daemonPlist(
        programPath: String,
        standardOutPath: String,
        standardErrorPath: String)
        -> LaunchdPlist
    {
        return LaunchdPlist(
            label: "ru.calcifer.app",
            programPath: programPath,
            standardOutPath: standardOutPath,
            standardErrorPath: standardErrorPath,
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
            "KeepAlive": keepAlive,
            "StandardOutPath": standardOutPath,
            "StandardErrorPath": standardErrorPath
        ]
    }
}
