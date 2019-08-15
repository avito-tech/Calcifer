import Foundation
import AtomicModels

public final class Throttler {
    // MARK: - Public properties
    public let delay: TimeInterval
    
    // MARK: - Private properties
    private var lastFireTime: AtomicValue<DispatchTime>
    
    // MARK: - Init
    public init(
        delay: TimeInterval)
    {
        assert(delay >= 0, "Throttler can't have negative delay")
        self.delay = delay
        self.lastFireTime = AtomicValue(.now() - delay)
    }
    
    // MARK: - Public
    public func throttle(_ closure: () -> ()) {
        let now = DispatchTime.now()
        let when = lastFireTime.currentValue() + delay
        if now >= when {
            fire(closure)
        }
    }
    
    // MARK: - Private
    private func fire(_ closure: () -> ()) {
        lastFireTime.set(.now())
        closure()
    }
}

