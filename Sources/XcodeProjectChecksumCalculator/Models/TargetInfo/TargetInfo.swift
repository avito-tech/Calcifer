import Foundation
import Checksum

public struct TargetInfo<ChecksumType: Checksum>: Equatable {
    
    public let targetName: String
    public let productName: String
    public let productType: String
    public let checksum: ChecksumType
    
    public init(
        targetName: String,
        productName: String,
        productType: String,
        checksum: ChecksumType)
    {
        self.targetName = targetName
        self.productName = productName
        self.productType = productType
        self.checksum = checksum
    }
}
