import Foundation

public struct FileWatcherEvent {
    public let eventId: UInt64
    public let path: String
    public let flags: FileWatcherEventFlag
}
