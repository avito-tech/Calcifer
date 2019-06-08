import Foundation

public enum CalciferVersionShipperError: Error, CustomStringConvertible {
    case emptyCalciferShipConfig
    
    public var description: String {
        switch self {
        case .emptyCalciferShipConfig:
            return "Calcifer ship config is empty"
        }
    }
}
