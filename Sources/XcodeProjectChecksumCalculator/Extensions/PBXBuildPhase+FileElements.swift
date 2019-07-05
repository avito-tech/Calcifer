import Foundation
import XcodeProj

public extension PBXBuildPhase {
    func fileElements() -> [PBXFileElement] {
        guard let files = files else { return [PBXFileElement]() }
        return files.compactMap { $0.file }
    }
}
