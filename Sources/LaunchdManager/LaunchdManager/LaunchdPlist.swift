import Foundation

public struct LaunchdPlist {
    public let label: String
    public let programPath: String
    public let standardOutPath: String
    public let standardErrorPath: String
    public let sessionType: LaunchdSessionType
    
    private let programArguments: [String]
    private let keepAlive: Bool
    private let runAtLoad: Bool
    
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
            sessionType: .background,
            programArguments: [
                programPath,
                "startDaemon"
            ],
            keepAlive: true,
            runAtLoad: true
        )
    }
    
    var content: [String: Any] {
        return [
            "Label": label,
            "ProgramArguments": programArguments,
            "LimitLoadToSessionType": sessionType.rawValue,
            "KeepAlive": keepAlive,
            "RunAtLoad": runAtLoad,
            "StandardOutPath": standardOutPath,
            "StandardErrorPath": standardErrorPath
        ]
    }
}
