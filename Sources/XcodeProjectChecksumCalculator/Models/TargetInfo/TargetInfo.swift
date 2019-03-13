import Foundation
import Checksum

public struct TargetInfo<ChecksumType: Checksum>: Equatable {
    
    public let targetName: String
    public let productName: String
    public let productType: TargetProductType
    public let checksum: ChecksumType
    
    public init(
        targetName: String,
        productName: String,
        productType: TargetProductType,
        checksum: ChecksumType)
    {
        self.targetName = targetName
        self.productName = productName
        self.productType = productType
        self.checksum = checksum
    }
}
