import Foundation
import Checksum
import BaseModels

public struct BuildProductCacheKey<ChecksumType: Checksum>: CustomStringConvertible {
    public let productName: String
    public let productType: BuildProductType
    public let checksum: ChecksumType
    
    public init(
        productName: String,
        productType: BuildProductType,
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
