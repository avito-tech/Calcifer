import Foundation

public extension OperationQueue {
    static func createSerialQueue(qualityOfService: QualityOfService = .`default`) -> OperationQueue {
        let operationQueue = OperationQueue()
        operationQueue.qualityOfService = .userInitiated
        operationQueue.maxConcurrentOperationCount = 1
        return operationQueue
    }
}
