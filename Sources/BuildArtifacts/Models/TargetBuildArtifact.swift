import Foundation
import XcodeProjectChecksumCalculator
import Checksum

public struct TargetBuildArtifact<ChecksumType: Checksum>: Hashable {
    
    public let targetInfo: TargetInfo<ChecksumType>
    public let productPath: String
    public let dsymPath: String
    
    public init(
        targetInfo: TargetInfo<ChecksumType>,
        productPath: String,
        dsymPath: String)
    {
        self.targetInfo = targetInfo
        self.productPath = productPath
        self.dsymPath = dsymPath
    }
}
