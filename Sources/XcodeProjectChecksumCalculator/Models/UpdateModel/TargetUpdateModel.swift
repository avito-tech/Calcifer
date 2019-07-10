import Foundation
import XcodeProj
import Checksum
import PathKit
import Toolkit

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Xcode models structure:                                                                                                //
// XcodeProj - root, represent *.xcodeproj file. It contains pbxproj file represented by Proj (Look below) and xcschemes. //
// Proj - represent project.pbxproj file. It contains all references to objects - projects, files, groups, targets etc.   //
// Project - represent build project. It contains build settings and targets.                                             //
// Target - represent build target. It contains build phases. For example source build phase.                             //
// File - represent source file. Can be obtained from source build phase.                                                 //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
final class TargetUpdateModel<ChecksumType: Checksum> {
    
    let target: PBXTarget
    let sourceRoot: Path
    let cache: ThreadSafeDictionary<String, TargetChecksumHolder<ChecksumType>>
    
    init(
        target: PBXTarget,
        sourceRoot: Path,
        cache: ThreadSafeDictionary<String, TargetChecksumHolder<ChecksumType>>)
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
