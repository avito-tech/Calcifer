import Foundation

public final class FrameworkBuilder {
    
    public init() {}
    
    @discardableResult
    public func build(config: TargetBuildConfig) -> Int32 {
        return shell(
            launchPath: "/usr/bin/xcodebuild",
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
                config.platform.rawValue,
                "build"
            ]
        )
    }
    
    // Use ProcessController from Emcee
    private func shell(launchPath: String, arguments: [String]) -> Int32 {
        let task = Process()
        task.launchPath = launchPath
        task.arguments = arguments
        task.environment = [:]
        task.launch()
        task.waitUntilExit()
        return task.terminationStatus
    }
}
