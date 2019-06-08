import Foundation
import Toolkit

public final class CalciferConfigProvider {
    
    private let fileManager: FileManager
    
    public init(fileManager: FileManager) {
        self.fileManager = fileManager
    }
    
    public func obtainGlobalConfig()  throws -> CalciferConfig {
        let path = globalConfigPath()
        let url = URL(fileURLWithPath: path)
        let jsonData = try Data(contentsOf: url)
        return try jsonData.decode()
    }
    
    public func obtainConfig(projectDirectoryPath: String) throws -> CalciferConfig {
        let globalConfig = try CalciferConfig.decode(from: globalConfigPath())
        let projectConfig = try CalciferConfig.decode(
            from: projectConfigPath(
                at: projectDirectoryPath,
                local: false
            )
        )
        let localProjectConfig = try CalciferConfig.decode(
            from: projectConfigPath(
                at: projectDirectoryPath,
                local: true
            )
        )
        return try globalConfig
            .override(by: projectConfig)
            .override(by: localProjectConfig)
    }
    
    private func projectConfigPath(at projectDirectoryPath: String, local: Bool) -> String {
        return projectDirectoryPath
            .appendingPathComponent(configFileName(local: local))
    }
    
    private func globalConfigPath() -> String {
        return fileManager.calciferDirectory()
            .appendingPathComponent(configFileName(local: false))
    }
    
    private func configFileName(local: Bool) -> String {
        if local {
            return "CalciferConfig.local.json"
        } else {
            return "CalciferConfig.json"
        }
    }
    
}
