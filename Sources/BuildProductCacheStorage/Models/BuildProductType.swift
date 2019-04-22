import Foundation

public enum TargetProductType: String {
    case framework = "Framework"
    case dSYM
    
    public var fileExtension: String {
        switch self {
        case .framework:
            return ".framework"
        case .dSYM:
            return ".framework.dSYM"
        }
    }
}
