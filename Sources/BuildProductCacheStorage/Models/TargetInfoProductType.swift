import Foundation
import BaseModels

public enum BuildProductType {
    case product(TargetProductType)
    case dSYM(TargetProductType)
    
    
    public var fileExtension: String {
        switch self {
        case let .product(type):
            return type.fileExtension
        case let .dSYM(type):
            return "\(type.fileExtension).dSYM"
        }
    }
    
    public var shortName: String {
        switch self {
        case let .product(type):
            return type.shortName
        case .dSYM:
            return "dSYM"
        }
    }
}
