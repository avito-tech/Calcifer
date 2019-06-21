import Foundation
import XcodeProj

public protocol XcodeProjCache {
    func fillXcodeProjCache(projectPath: String) throws
    func obtainXcodeProj(projectPath: String) throws -> XcodeProj
    func obtainWritableXcodeProj(projectPath: String) throws -> XcodeProj
}
