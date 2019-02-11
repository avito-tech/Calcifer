import Foundation

public struct BuildConfig {
    
    public enum SDK: String {
        case simulator = "iphonesimulator"
        case device = "iphoneos"
    }
    public let SDK: SDK
    
    public enum Architecture: String {
        case x86_64
        case i386
    }
    public let architecture: Architecture
    
    public let projectPath: String
    public let targetName: String
    public let configurationName: String
    public let onlyActiveArchitecture: Bool

}

public final class FrameworkBuilder {
    
    public init() {}
    
    @discardableResult
    func build(config: BuildConfig) -> Int32 {
        return shell(
            launchPath: "xcodebuild",
            arguments: [
                "ARCHS=\(config.architecture.rawValue)",
                "ONLY_ACTIVE_ARCH=\(config.onlyActiveArchitecture ? "YES" : "NO")",
                "-project",
                config.projectPath,
                "-target",
                config.targetName,
                "-configuration",
                config.configurationName,
                "-sdk",
                config.SDK.rawValue,
                "build"
            ]
        )
    }
    
    // Use ProcessController from Emcee
    private func shell(launchPath: String, arguments: [String]) -> Int32 {
        let task = Process()
        task.launchPath = launchPath
        task.arguments = arguments
        task.launch()
        task.waitUntilExit()
        return task.terminationStatus
    }
}
