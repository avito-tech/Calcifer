import Foundation
import Toolkit
import Swifter

final class WebSocketSessionWriter {
    
    let session: WebSocketSession
    
    private let operationQueue = OperationQueue.createSerialQueue()
    
    init(session: WebSocketSession) {
        self.session = session
    }
    
    var state: SessionWriterState {
        set {
            switch newValue {
            case .active:
                operationQueue.isSuspended = false
            case .suspended:
                operationQueue.isSuspended = true
            }
        }
        get {
            return operationQueue.isSuspended ? .suspended : .active
        }
    }
    
    func write<T: Encodable>(_ object: T) {
        operationQueue.addOperation { [weak self] in
            self?.performWrite(object)
        }
    }
    
    private func performWrite<T: Encodable>(_ object: T) {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(object)
            if data.isEmpty == false {
                session.writeBinary([UInt8](data))
            } else {
                Logger.warning("Try to send empty data. Object \(object)")
            }
        } catch {
            Logger.warning("Failed decode object \(object)")
        }
    }
}
