import Foundation

public struct XcodeProjectBuildConfig {
    
    public enum Platform: String {
        case simulator = "iphonesimulator"
        case device = "iphoneos"
    }
    public let platform: Platform
    
    public enum Architecture: String {
        case x86_64
        case i386
    }
    public let architecture: Architecture
    
    public let projectPath: String
    public let targetName: String
    public let configurationName: String
    public let onlyActiveArchitecture: Bool
    
    public init(
        platform: Platform,
        architecture: Architecture,
        projectPath: String,
        targetName: String,
        configurationName: String,
        onlyActiveArchitecture: Bool)
    {
        self.platform = platform
        self.architecture = architecture
        self.projectPath = projectPath
        self.targetName = targetName
        self.configurationName = configurationName
        self.onlyActiveArchitecture = onlyActiveArchitecture
    }
    
}
