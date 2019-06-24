import Foundation
import FileWatcher

public protocol Warmer {
    func warmup(
        for event: WarmerEvent,
        perform: @escaping (Operation) -> ()
    )
}
