import Foundation
import XcodeProj
import Checksum
import PathKit
import Toolkit

final class TargetUpdateModel<ChecksumType: Checksum> {
    
    let target: PBXTarget
    let sourceRoot: Path
    let cache: ThreadSafeDictionary<PBXTarget, TargetChecksumHolder<ChecksumType>>
    
    init(
        target: PBXTarget,
        sourceRoot: Path,
        cache: ThreadSafeDictionary<PBXTarget, TargetChecksumHolder<ChecksumType>>)
    {
        self.target = target
        self.sourceRoot = sourceRoot
        self.cache = cache
    }
    
    var targetName: String {
        return target.name
    }
    
    var productName: String {
        let type = productType
        if let productName = target.product?.name,
            isValidProductName(productName, type: type) {
            return productName
        }
        if let productName = target.product?.path,
            isValidProductName(productName, type: type) {
            return productName
        }
        if let productName = target.productNameWithExtension(),
            isValidProductName(productName, type: type) {
            return productName
        }
        return target.name
    }
    
    var productType: TargetProductType {
        if let productTypeName = target.productType?.rawValue,
            let currentProductType = TargetProductType(rawValue: productTypeName) {
            return currentProductType
        } else {
            return .none
        }
    }
    
    var name: String {
        return "\(targetName)-\(productName)-\(productType)"
    }
    
    private func isValidProductName(_ productName: String, type: TargetProductType) -> Bool {
        switch type {
        case .framework:
            return productName.contains("-") == false
        default:
            return true
        }
    }
}
