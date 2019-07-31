import Foundation
import FileWatcher

public enum WarmerEvent: CustomDebugStringConvertible {
    case initial
    case file(FileWatcherEvent)
    case manual
    
    public var debugDescription: String {
        switch self {
        case .initial:
            return "initial"
        case let .file(event):
            return "File - \(event)"
        case .manual:
            return "manual"
        }
    }
}
