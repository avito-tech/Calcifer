import Foundation
import XcodeProj
import PathKit

public protocol FileElementFullPathProvider {
    func fullPath(for fileElement: PBXFileElement, sourceRoot: Path) throws -> Path
}
