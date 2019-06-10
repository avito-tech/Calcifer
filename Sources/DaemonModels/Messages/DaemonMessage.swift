import Foundation
import Toolkit

public enum DaemonMessage: Codable {
    case standardStream(StandardStreamMessage)
    case logger(LoggerMessage)
    case exitCode(CommandExitCodeMessage)
    
    private enum CodingKeys: String, CodingKey {
        case standardStream
        case logger
        case exitCode
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let standardStreamMessage = try container.decodeIfPresent(
            StandardStreamMessage.self,
            forKey: .standardStream)
        {
            self = .standardStream(standardStreamMessage)
            return
        }
        if let loggerMessage = try container.decodeIfPresent(
            LoggerMessage.self,
            forKey: .logger)
        {
            self = .logger(loggerMessage)
            return
        }
        let exitCodeMessage = try container.decode(
            CommandExitCodeMessage.self,
            forKey: .exitCode
        )
        self = .exitCode(exitCodeMessage)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case let .standardStream(message):
            try container.encode(message, forKey: .standardStream)
        case let .logger(message):
            try container.encode(message, forKey: .logger)
        case let .exitCode(message):
            try container.encode(message, forKey: .exitCode)
        }
    }
}
