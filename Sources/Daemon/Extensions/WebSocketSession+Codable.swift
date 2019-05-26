import Foundation
import Swifter
import Toolkit

extension WebSocketSession {    
    func write<T: Encodable>(_ object: T) {
        let encoder = JSONEncoder()
        let data = catchError { try encoder.encode(object) }
        writeBinary([UInt8](data))
    }
}
