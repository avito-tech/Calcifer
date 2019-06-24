import Foundation
import FileWatcher

public enum WarmerEvent {
    case initial
    case file(FileWatcherEvent)
    case manual
}
