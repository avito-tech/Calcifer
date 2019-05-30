import Foundation

public struct XcodeProjectBuildConfig {
    
    public let platform: Platform
    
    public let architectures: [Architecture]
    
    public let buildDirectoryPath: String
    public let projectPath: String
    public let targetName: String
    public let configurationName: String
    public let onlyActiveArchitecture: Bool
    
    public init(
        platform: Platform,
        architectures: [Architecture],
        buildDirectoryPath: String,
        projectPath: String,
        targetName: String,
        configurationName: String,
        onlyActiveArchitecture: Bool)
    {
        self.platform = platform
        self.architectures = architectures
        self.buildDirectoryPath = buildDirectoryPath
        self.projectPath = projectPath
        self.targetName = targetName
        self.configurationName = configurationName
        self.onlyActiveArchitecture = onlyActiveArchitecture
    }
    
}
