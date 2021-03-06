import Foundation
import Toolkit

public class FileWatcherImpl: FileWatcher {
    
    private var subscribers = [(FileWatcherEvent) -> ()]()
    
    private var started = false
    private var streamRef: FSEventStreamRef?
    private let latency: TimeInterval = 1.0 / 60.0
    private var lastEventId = FSEventStreamEventId(kFSEventStreamEventIdSinceNow)
    
    public init() {}
    
    deinit {
        stop()
    }
    
    public func subscribe(_ subscriber: @escaping FileEventSubscriber) {
        subscribers.append(subscriber)
    }
    
    private let eventCallback: FSEventStreamCallback = {
        (stream: ConstFSEventStreamRef,
        contextInfo: UnsafeMutableRawPointer?,
        numEvents: Int,
        eventPaths: UnsafeMutableRawPointer,
        eventFlags: UnsafePointer<FSEventStreamEventFlags>,
        eventIds: UnsafePointer<FSEventStreamEventId>) in
        
        let fileSystemWatcher: FileWatcherImpl = unsafeBitCast(contextInfo, to: FileWatcherImpl.self)
        
        guard let paths = unsafeBitCast(eventPaths, to: NSArray.self) as? [String] else { return }
        
        for index in 0..<numEvents {
            fileSystemWatcher.processEvent(
                eventId: eventIds[index],
                eventPath: paths[index],
                eventFlags: eventFlags[index]
            )
        }
        
        fileSystemWatcher.lastEventId = eventIds[numEvents - 1]
    }
    
    private func processEvent(
        eventId: FSEventStreamEventId,
        eventPath: String,
        eventFlags: FSEventStreamEventFlags)
    {
        let event = FileWatcherEvent(
            eventId: eventId,
            path: eventPath,
            flags: FileWatcherEventFlag(rawValue: eventFlags)
        )
        for subscriber in subscribers {
            subscriber(event)
        }
    }
    
    public func start(path: String) {
        guard started == false else { return }
        var context = FSEventStreamContext(
            version: 0,
            info: nil,
            retain: nil,
            release: nil,
            copyDescription: nil
        )
        context.info = Unmanaged.passUnretained(self).toOpaque()
        let flags = UInt32(kFSEventStreamCreateFlagUseCFTypes | kFSEventStreamCreateFlagFileEvents)
        guard let stream = FSEventStreamCreate(
            kCFAllocatorDefault,
            eventCallback,
            &context,
            [path] as CFArray,
            lastEventId,
            latency,
            flags
        ) else { return }
        self.streamRef = stream
        FSEventStreamScheduleWithRunLoop(
            stream,
            CFRunLoopGetMain(),
            CFRunLoopMode.defaultMode.rawValue
        )
        FSEventStreamStart(stream)
        started = true
    }
    
    public func stop() {
        guard started == true else { return }
        guard let streamRef = streamRef else {
            return
        }
        FSEventStreamStop(streamRef)
        FSEventStreamInvalidate(streamRef)
        FSEventStreamRelease(streamRef)
        self.streamRef = nil
        
        started = false
    }
}
