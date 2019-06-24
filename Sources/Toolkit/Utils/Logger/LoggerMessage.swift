import Foundation
import SwiftyBeaver

extension SwiftyBeaver.Level: Codable {}

public struct LoggerMessage: Codable {
    public let level: SwiftyBeaver.Level
    public let message: String
    public let thread: String
    public let file: String
    public let function: String
    public let line: Int
}
