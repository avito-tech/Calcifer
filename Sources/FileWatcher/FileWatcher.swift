import Foundation

public protocol FileWatcher: FileEventNotifier {
    
    func start(path: String)
    
    func stop()
}
