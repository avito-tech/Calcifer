import Foundation
import SwiftyBeaver

public class CustomLoggerDestination: BaseDestination {
    
    public let onNewMessage: (LoggerMessage) -> ()
    
    public init(onNewMessage: @escaping (LoggerMessage) -> ()) {
        self.onNewMessage = onNewMessage
    }
    
    override public func send(
        _ level: SwiftyBeaver.Level,
        msg: String,
        thread: String,
        file: String,
        function: String,
        line: Int,
        context: Any? = nil)
        -> String?
    {
        let message = LoggerMessage(
            level: level,
            message: msg,
            thread: thread,
            file: file,
            function: function,
            line: line
        )
        onNewMessage(message)
        return nil
    }
    
}
