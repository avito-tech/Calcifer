import Foundation

public protocol FileWatcher {
    
    func subscribe(
        _ closure: @escaping (_ event: FileWatcherEvent) -> ()
    )
    
    func start(path: String)
    
    func stop()
}
