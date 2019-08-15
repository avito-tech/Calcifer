import Foundation
import AtomicModels

public protocol Debouncable {
    func debounce(_ closure: @escaping () -> ())
    func cancel()
}

public final class Debouncer: Debouncable {
    private var lastFireTime = AtomicValue(DispatchTime(uptimeNanoseconds: 0))
    private let queue: DispatchQueue
    private let delay: TimeInterval
    
    public init(delay: TimeInterval, queue: DispatchQueue = DispatchQueue.main) {
        self.delay = delay
        self.queue = queue
    }
    
    public func debounce(_ closure: @escaping () -> ()) {
        lastFireTime.set(DispatchTime.now())
        queue.asyncAfter(deadline: .now() + delay) { [weak self] in
            guard let strongSelf = self else { return }
            if DispatchTime.now() >= strongSelf.lastFireTime.currentValue() + strongSelf.delay {
                closure()
            }
        }
    }
    
    public func cancel() {
        debounce {}
    }
}
