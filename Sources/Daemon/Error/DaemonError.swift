import Foundation

public enum DaemonError: Error, CustomStringConvertible {
    case someError(path: String)
    
    public var description: String {
        switch self {
        case let .someError(path):
            return "someError \(path)"
        }
    }
}
