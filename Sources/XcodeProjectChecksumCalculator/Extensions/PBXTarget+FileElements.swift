import Foundation
import XcodeProj

public extension PBXTarget {
    func fileElements() -> [PBXFileElement] {
        var files = [PBXFileElement]()
        if let sourcesBuildPhase = try? sourcesBuildPhase() {
            let sourcesFileElement = sourcesBuildPhase.fileElements()
            files.append(contentsOf: sourcesFileElement)
        }
        
        if let productType = productType, case .bundle = productType {
            if let resourcesBuildPhase = try? resourcesBuildPhase() {
                let resourcesFileElement = resourcesBuildPhase.fileElements()
                files.append(contentsOf: resourcesFileElement)
            }
        }
        return files
    }
}
