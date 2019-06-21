import Foundation

public protocol FileWatcher {
    
    func subscribe(
        _ closure: @escaping (_ events: FileWatcherEvent) -> ()
    )
    
    func start(path: String)
    
    func stop()
}
