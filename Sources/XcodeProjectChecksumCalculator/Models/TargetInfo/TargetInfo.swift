import Foundation
import Checksum

public struct TargetInfo<ChecksumType: Checksum> {
    
    public let targetName: String
    public let productName: String
    public let checksum: ChecksumType
    
    public init(
        targetName: String,
        productName: String,
        checksum: ChecksumType)
    {
        self.targetName = targetName
        self.productName = productName
        self.checksum = checksum
    }
}
