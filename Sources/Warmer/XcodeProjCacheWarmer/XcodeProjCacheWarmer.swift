import Foundation

public protocol XcodeProjCacheWarmer {
    func warmup(projectPath: String) throws
}
