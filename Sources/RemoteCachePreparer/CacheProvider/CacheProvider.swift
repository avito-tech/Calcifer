import Foundation
import XcodeProjectChecksumCalculator
import XcodeProjCache
import Checksum

public protocol CacheProvider {
    var fileManager: FileManager { get }
    var baseURLChecksumProducer: BaseURLChecksumProducer { get }
    var xcodeProjCache: XcodeProjCache { get }
    var baseXcodeProjChecksumCache: BaseXcodeProjChecksumCache { get }
    var artifactBuildSourcePathCache: ArtifactBuildSourcePathCache { get }
}
