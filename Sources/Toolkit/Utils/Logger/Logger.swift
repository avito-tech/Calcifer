import Foundation
import SwiftyBeaver

public final class Logger {
    
    private static var logger: SwiftyBeaver.Type = {
        let swiftyBeaver = SwiftyBeaver.self
        addConsoleDestination()
        return swiftyBeaver
    }()
    
    public static var minLogLevel: SwiftyBeaver.Level {
        let minLogLevel: SwiftyBeaver.Level
        if ProcessInfo.processInfo.environment["VERBOSE"] != nil {
            minLogLevel = .verbose
        } else {
            minLogLevel = isDebuggerAttached ? .verbose : .info
        }
        return minLogLevel
    }
    
    private static func setupLevelString(_ destination: BaseDestination) {
        // lowercase for xcode highlighting
        destination.levelString.verbose = "verbose"
        destination.levelString.debug = "debug"
        destination.levelString.info = "info"
        destination.levelString.warning = "warning"
        destination.levelString.error = "error"
    }
    
    public static func addConsoleDestination() {
        let swiftyBeaver = SwiftyBeaver.self
        let consoleDestination = ConsoleDestination()
        consoleDestination.format = "$L: $M"
        setupLevelString(consoleDestination)
        consoleDestination.asynchronously = false
        consoleDestination.useTerminalColors = isDebuggerAttached == false
        consoleDestination.minLevel = minLogLevel
        swiftyBeaver.addDestination(consoleDestination)
    }
    
    public static func addFileDestination(folderName: String) {
        let swiftyBeaver = SwiftyBeaver.self
        let fileDestination = FileDestination()
        fileDestination.format = "$DHH:mm:ss.SSS$d $L: $M"
        setupLevelString(fileDestination)
        let logFile = logFileURL(folderName: folderName)
        fileDestination.logFileURL = logFile
        fileDestination.asynchronously = false
        fileDestination.minLevel = .verbose
        SwiftyBeaver.info("Write logs to \(logFile)")
        swiftyBeaver.addDestination(fileDestination)
    }
    
    public static func addDestination(_ destination: BaseDestination) {
        let swiftyBeaver = SwiftyBeaver.self
        swiftyBeaver.addDestination(destination)
    }
    
    public static func removeAllDestinations() {
        let swiftyBeaver = SwiftyBeaver.self
        swiftyBeaver.removeAllDestinations()
    }
    
    public static func removeAllDestinations<DestinationType: BaseDestination>(type: DestinationType.Type) {
        let swiftyBeaver = SwiftyBeaver.self
        let destinations = swiftyBeaver.destinations
        for destination in destinations {
            if let destinationForRemoving = destination as? DestinationType {
                swiftyBeaver.removeDestination(destinationForRemoving)
            }
        }
    }
    
    public static func verbose(
        _ message: String,
        _ file: String = #file,
        _ function: String = #function,
        _ line: Int = #line)
    {
        logger.verbose(message, file, function, line: line)
    }
    
    public static func debug(
        _ message: String,
        _ file: String = #file,
        _ function: String = #function,
        _ line: Int = #line)
    {
        logger.debug(message, file, function, line: line)
    }
    
    public static func info(
        _ message: String,
        _ file: String = #file,
        _ function: String = #function,
        _ line: Int = #line)
    {
        logger.info(message, file, function, line: line)
    }
    
    public static func warning(
        _ message: String,
        _ file: String = #file,
        _ function: String = #function,
        _ line: Int = #line)
    {
        logger.warning(message, file, function, line: line)
    }
    
    public static func error(
        _ message: String,
        _ file: String = #file,
        _ function: String = #function,
        _ line: Int = #line)
    {
        logger.error(message)
    }
    
    public static func log(_ loggerMessage: LoggerMessage) {
        for destination in SwiftyBeaver.destinations {
            guard loggerMessage.level.rawValue >= destination.minLevel.rawValue else {
                return
            }
            _ = destination.send(
                loggerMessage.level,
                msg: loggerMessage.message,
                thread: loggerMessage.thread,
                file: loggerMessage.file,
                function: loggerMessage.function,
                line: loggerMessage.line
            )
        }
    }
    
    private static func logFileURL(folderName: String) -> URL {
        let fileManager = FileManager.default
        let pathProvider = CalciferPathProviderImpl(fileManager: fileManager)
        let logDirectory = pathProvider.calciferLogsDirectory()
            .appendingPathComponent(folderName)
        try? fileManager.createDirectory(
            atPath: logDirectory,
            withIntermediateDirectories: true
        )
        let logFilePath = logDirectory
            .appendingPathComponent(Date().formattedString())
            .appending(".log")
        let logFile = URL(fileURLWithPath: logFilePath)
        return logFile
    }
    
    private static var isDebuggerAttached: Bool = {
        var info = kinfo_proc()
        var mib : [Int32] = [CTL_KERN, KERN_PROC, KERN_PROC_PID, getpid()]
        var size = MemoryLayout<kinfo_proc>.stride
        let junk = sysctl(&mib, UInt32(mib.count), &info, &size, nil, 0)
        return (info.kp_proc.p_flag & P_TRACED) == P_TRACED
    }()
    
}
