import Foundation

public typealias FileEventSubscriber = (FileWatcherEvent) -> ()

public protocol FileEventNotifier {
    func subscribe(
        _ subscriber: @escaping FileEventSubscriber
    )
}
