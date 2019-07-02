import Foundation

public enum LaunchdManagerError: Error, CustomStringConvertible {
    case failedToLoadPlistToLaunchctl(error: String?)
    case failedToUnloadPlistToLaunchctl(error: String?)
    case failedToReceiveUserIdentifier(error: String?)
    
    public var description: String {
        switch self {
        case let .failedToLoadPlistToLaunchctl(error):
            return "Failed to load plist to launchctl with error \(error ?? "-")"
        case let .failedToUnloadPlistToLaunchctl(error):
            return "Failed to unload plist to launchctl with error \(error ?? "-")"
        case let .failedToReceiveUserIdentifier(error):
            return "Failed to receive user identifier with error \(error ?? "-")"
        }
    }
}
