import Foundation
import XcodeProjCache
import XcodeProj

public final class XcodeProjCacheStub: XcodeProjCache {
    
    var onFillXcodeProjCache: ((String) -> ())?
    public func fillXcodeProjCache(projectPath: String) throws {
        onFillXcodeProjCache?(projectPath)
    }
    
    public func obtainXcodeProj(projectPath: String) throws -> XcodeProj {
        return try XcodeProj(pathString: projectPath)
    }
    
    public func obtainWritableXcodeProj(projectPath: String) throws -> XcodeProj {
        return try XcodeProj(pathString: projectPath)
    }
}
