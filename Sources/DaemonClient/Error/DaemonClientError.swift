import Foundation

public enum DaemonClientError: Error, CustomStringConvertible {
    case unableToCreateDaemonURL
    
    public var description: String {
        switch self {
        case .unableToCreateDaemonURL:
            return "Unable to create daemon url"
        }
    }
}
