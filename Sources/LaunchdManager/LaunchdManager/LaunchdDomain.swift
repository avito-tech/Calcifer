import Foundation

public enum LaunchdDomain {
    case system
    case user(userId: String)
    case gui(userId: String)
    
    var stringValue: String {
        switch self {
        case .system:
            return "system"
        case let .user(userId):
            return "user/\(userId)"
        case let .gui(userId):
            return "gui/\(userId)"
        }
    }
}
