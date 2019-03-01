import Foundation
import xcodeproj
import PathKit

protocol FileElementFullPathProvider {
    func fullPath(for fileElement: PBXFileElement, sourceRoot: Path) throws -> Path
}
