import Foundation

public struct CacheHitRationEntry {
    let moduleName: String
    let resolution: CacheResolution
    
    public init(moduleName: String, resolution: CacheResolution) {
        self.moduleName = moduleName
        self.resolution = resolution
    }
}
