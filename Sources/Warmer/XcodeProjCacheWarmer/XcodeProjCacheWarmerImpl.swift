import Foundation
import XcodeProjCache
import Toolkit

final class XcodeProjCacheWarmerImpl: XcodeProjCacheWarmer {
    private let xcodeProjCache: XcodeProjCache
    
    public init(xcodeProjCache: XcodeProjCache) {
        self.xcodeProjCache = xcodeProjCache
    }
    
    public func warmup(projectPath: String) throws {
        TimeProfiler.measure("Fill xcode project cache") {
            try xcodeProjCache.fillXcodeProjCache(
                projectPath: projectPath
            )
        }
    }
}
