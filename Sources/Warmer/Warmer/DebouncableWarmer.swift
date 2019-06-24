import Foundation
import Toolkit

public final class DebouncingWarmer: Warmer {
    
    private let debouncer: Debouncer
    private let warmer: Warmer
    
    public init(warmer: Warmer, delay: TimeInterval = 30) {
        self.warmer = warmer
        self.debouncer = Debouncer(delay: delay)
    }
    
    public func warmup(
        for event: WarmerEvent,
        perform: @escaping (Operation) -> ())
    {
        warmer.warmup(for: event) { [debouncer] operation in
            debouncer.debounce {
                perform(operation)
            }
        }
    }
    
}
