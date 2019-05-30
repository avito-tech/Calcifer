import Foundation

public enum BuildLogLevel: Int, Codable {
    case verbose = 0
    case info = 2
    case warning = 3
    case error = 4
}
