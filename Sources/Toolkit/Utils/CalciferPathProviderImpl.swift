import Foundation

public final class CalciferPathProviderImpl: CalciferPathProvider {
    
    private let fileManager: FileManager
    
    public init(fileManager: FileManager) {
        self.fileManager = fileManager
    }
    
    public func calciferDirectory() -> String {
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
    
    public func calciferCheckumFilePath() -> String {
        return calciferDirectory()
            .appendingPathComponent("checkum.json")
    }
    
    public func calciferEnvironmentFilePath() -> String {
        return calciferDirectory()
            .appendingPathComponent("calciferenv.json")
    }
    
    public func calciferBuildLogDirectory() -> String {
        return calciferDirectory()
            .appendingPathComponent("buildlogs")
    }
    
}
