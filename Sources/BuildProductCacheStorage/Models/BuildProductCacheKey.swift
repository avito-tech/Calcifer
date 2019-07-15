import Foundation
import Checksum

public struct BuildProductCacheKey<ChecksumType: Checksum>: CustomStringConvertible {
    public let productName: String
    public let productType: TargetProductType
    public let checksum: ChecksumType
    
    public init(
        productName: String,
        productType: TargetProductType,
        checksum: ChecksumType)
    {
        self.productName = productName
        self.productType = productType
        self.checksum = checksum
    }
    
    public var description: String {
        return "\(productName) \(productType) \(checksum.stringValue)"
    }
}
