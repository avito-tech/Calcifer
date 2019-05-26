import Foundation
import SwiftyBeaver

public final class Logger {
    
    private static var logger: SwiftyBeaver.Type = {
        let swiftyBeaver = SwiftyBeaver.self
        addConsoleDestination()
        addFileDestination()
        return swiftyBeaver
    }()
    
    public static var minLogLevel: SwiftyBeaver.Level {
        let minLogLevel: SwiftyBeaver.Level
        if let _ = ProcessInfo.processInfo.environment["VERBOSE"] {
            minLogLevel = .verbose
        } else {
            minLogLevel = isDebuggerAttached ? .verbose : .info
        }
        return minLogLevel
    }
    
    public static func addConsoleDestination() {
        let swiftyBeaver = SwiftyBeaver.self
        let consoleDestination = ConsoleDestination()
        consoleDestination.asynchronously = false
        consoleDestination.useTerminalColors = isDebuggerAttached == false
        consoleDestination.minLevel = minLogLevel
        swiftyBeaver.addDestination(consoleDestination)
    }
    
    public static func addFileDestination() {
        let swiftyBeaver = SwiftyBeaver.self
        let fileDestination = FileDestination()
        fileDestination.logFileURL = logFileURL()
        fileDestination.asynchronously = false
        fileDestination.minLevel = .verbose
        swiftyBeaver.addDestination(fileDestination)
    }
    
    public static func addDestination(_ destination: BaseDestination) {
        let swiftyBeaver = SwiftyBeaver.self
        swiftyBeaver.addDestination(destination)
    }
    
    public static func removeAllDestination() {
        let swiftyBeaver = SwiftyBeaver.self
        swiftyBeaver.removeAllDestinations()
    }
    
    public static func disableFileLog() {
        let swiftyBeaver = SwiftyBeaver.self
        let destinations = swiftyBeaver.destinations
        for destination in destinations {
            if let fileDestination = destination as? FileDestination {
                swiftyBeaver.removeDestination(fileDestination)
            }
        }
    }
    
    public static func verbose(_ message: String) {
        logger.verbose(message)
    }
    
    public static func debug(_ message: String) {
        logger.debug(message)
    }
    
    public static func info(_ message: String) {
        logger.info(message)
    }
    
    public static func warning(_ message: String) {
        logger.warning(message)
    }
    
    public static func error(_ message: String) {
        logger.error(message)
        fatalError(message)
    }
    
    private static func logFileURL() -> URL {
        let fileManager = FileManager.default
        let logDirectory = fileManager.calciferDirectory()
            .appendingPathComponent("logs")
        try? fileManager.createDirectory(
            atPath: logDirectory,
            withIntermediateDirectories: true
        )
        let logFilePath = logDirectory
            .appendingPathComponent(Date().string())
            .appending(".txt")
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
