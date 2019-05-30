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
    
    public func obtainConfig(path: String) throws -> CalciferConfig {
        let globalConfigDictionary = try obtainConfigDicationary(from: globalConfigPath())
        let localConfigDictionary = try obtainConfigDicationary(from: path)
        let mergedDictionary = globalConfigDictionary.merging(localConfigDictionary) { (_, new) in new }
        let jsonData = try JSONSerialization.data(withJSONObject: mergedDictionary)
        return try jsonData.decode()
    }
    
    private func globalConfigPath() -> String {
        return fileManager.calciferDirectory()
            .appendingPathComponent(configFileName())
    }
    
    private func obtainConfigDicationary(from path: String) throws -> [String: Any] {
        guard fileManager.fileExists(atPath: path) else { return [:] }
        let url = URL(fileURLWithPath: path)
        let jsonData = try Data(contentsOf: url)
        let jsonObject = try JSONSerialization.jsonObject(with: jsonData)
        guard let jsonResult = jsonObject as? [String: Any]
            else { return [:] }
        return jsonResult
    }
    
    public func configFileName() -> String {
        return "CalciferConfig.json"
    }
    
}
