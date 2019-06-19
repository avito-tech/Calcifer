import Foundation
import XcodeProj

public protocol XcodeProjCache {
    func obtainXcodeProj(projectPath: String) throws -> XcodeProj
    func obtainWritableXcodeProj(projectPath: String) throws -> XcodeProj
}
