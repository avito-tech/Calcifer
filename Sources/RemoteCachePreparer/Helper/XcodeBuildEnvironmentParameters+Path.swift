import Foundation
import XcodeBuildEnvironmentParametersParser
import XcodeProjectChecksumCalculator
import Checksum

extension XcodeBuildEnvironmentParameters {
    
    var patchedProjectPath: String {
        let patchedProjectFileName = "\(targetName)-RemoteCache.xcodeproj"
        let patchedProjectPath = podsRoot + "/" + patchedProjectFileName
        return patchedProjectPath
    }
    
}
