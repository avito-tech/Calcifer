import Foundation
@testable import XcodeProjectChecksumCalculator
import XcodeProj
import PathKit

final class TestFileElementFullPathProvider: FileElementFullPathProvider {
    
    func fullPath(for file: PBXFileElement, sourceRoot: Path) throws -> Path {
        guard let filePath = file.path else {
            return sourceRoot
        }
        return sourceRoot + Path(filePath)
    }
    
}
