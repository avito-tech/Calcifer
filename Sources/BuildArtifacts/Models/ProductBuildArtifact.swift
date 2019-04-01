import Foundation
import XcodeProjectChecksumCalculator
import Checksum

public struct ProductBuildArtifact<ChecksumType: Checksum> {
    
    public let targetInfo: TargetInfo<ChecksumType>
    public let path: String
    
    public init(
        targetInfo: TargetInfo<ChecksumType>,
        path: String)
    {
        self.targetInfo = targetInfo
        self.path = path
    }
}
