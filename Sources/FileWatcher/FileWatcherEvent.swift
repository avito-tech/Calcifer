import Foundation

public struct FileWatcherEvent: CustomDebugStringConvertible {
    public let eventId: UInt64
    public let path: String
    public let flags: FileWatcherEventFlag
    
    public var debugDescription: String {
        return "FileWatcherEvent eventId: \(eventId) path: \(path) flags: \(flags.description)"
    }
}
