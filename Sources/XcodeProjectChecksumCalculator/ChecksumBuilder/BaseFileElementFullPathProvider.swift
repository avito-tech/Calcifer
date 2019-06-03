import Foundation
import XcodeProj
import PathKit

public final class BaseFileElementFullPathProvider: FileElementFullPathProvider {
    
    public init() {}
    
    public func fullPath(for file: PBXFileElement, sourceRoot: Path) throws -> Path {
        guard let filePath = try file.fullPath(sourceRoot: sourceRoot) else {
            throw XcodeProjectChecksumCalculatorError.emptyFullFilePath(
                name: file.name,
                path: file.path
            )
        }
        return filePath
    }
    
}
