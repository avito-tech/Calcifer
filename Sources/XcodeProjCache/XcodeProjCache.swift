import Foundation
import XcodeProj

public protocol XcodeProjCache {
    func obtainXcodeProj(projectPath: String) throws -> XcodeProj
}
