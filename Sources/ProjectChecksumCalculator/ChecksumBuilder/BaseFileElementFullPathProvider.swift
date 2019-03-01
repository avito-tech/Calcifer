import Foundation
import xcodeproj
import PathKit

final class BaseFileElementFullPathProvider: FileElementFullPathProvider {
    
    func fullPath(for file: PBXFileElement, sourceRoot: Path) throws -> Path {
        guard let filePath = try file.fullPath(sourceRoot: sourceRoot) else {
            throw ProjectChecksumError.emptyFullFilePath(
                name: file.name,
                path: file.path
            )
        }
        return filePath
    }
    
}
