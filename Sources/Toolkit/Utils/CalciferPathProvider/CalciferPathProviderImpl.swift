import Foundation

open class CalciferPathProviderImpl: CalciferPathProvider {
    
    private let fileManager: FileManager
    
    public init(fileManager: FileManager) {
        self.fileManager = fileManager
    }
    
    open func calciferDirectory() -> String {
        // .noindex - remove from spotlight index
        return fileManager
            .home()
            .appendingPathComponent(".calcifer.noindex")
    }
    
    public func calciferBinaryName() -> String {
        return "Calcifer"
    }
    
    public func calciferBinaryPath() -> String {
        return calciferDirectory()
            .appendingPathComponent(calciferBinaryName())
    }
    
    public func calciferLogsDirectory() -> String {
        return calciferDirectory()
            .appendingPathComponent("logs")
    }
    
    public func calciferChecksumDirectory() -> String {
        return calciferDirectory()
            .appendingPathComponent("checksums")
    }
    
    public func calciferChecksumFilePath(for date: Date) -> String {
        return calciferChecksumDirectory()
            .appendingPathComponent("checksum-\(date.formattedString()).json")
    }
    
    public func calciferEnvironmentFilePath() -> String {
        return calciferDirectory()
            .appendingPathComponent("calciferenv.json")
    }
    
    public func calciferBuildLogDirectory() -> String {
        return calciferDirectory()
            .appendingPathComponent("buildlogs")
    }
    
    public func launchAgentPlistPath(label: String) -> String {
        return fileManager.home()
            .appendingPathComponent("Library")
            .appendingPathComponent("LaunchAgents")
            .appendingPathComponent("\(label).plist")
    }
    
    public func launchctlLogDirectory() -> String {
        return calciferDirectory()
            .appendingPathComponent("launchctl")
    }
    
    public func launchctlStandardOutPath() -> String {
        return launchctlLogDirectory()
            .appendingPathComponent("out.log")
    }
    
    public func launchctlStandardErrorPath() -> String {
        return launchctlLogDirectory()
            .appendingPathComponent("error.log")
    }
    
}
