import Foundation
import xcodeproj

public protocol XcodeProjCache {
    func obtainXcodeProj(projectPath: String) throws -> XcodeProj
}
