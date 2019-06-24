import Foundation

public typealias FileEventSubscriber = (FileWatcherEvent) -> ()

public protocol FileWatcher {
    
    func subscribe(
        _ subscriber: @escaping FileEventSubscriber
    )
    
    func start(path: String)
    
    func stop()
}
