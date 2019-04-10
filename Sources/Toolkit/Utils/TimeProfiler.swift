import Foundation

public final class TimeProfiler {
    
    public typealias TimeMeasurementTimestamp = TimeInterval
    public typealias TimeMeasurementDescription = String
    
    @discardableResult
    public static func measure<R>(
        _ description: TimeMeasurementDescription,
        action: (() throws -> (R)))
        throws -> R
    {
        let start = timestamp()
        let result = try action()
        let duration = timestamp() - start
        let durationString = formatDuration(duration)
        Logger.verbose("Duration of \(description) is \(durationString)")
        return result
    }
    
    private static func formatDuration(_ duration: Double) -> String {
        if duration < 1 {
            return String(format:"%.2f ms", duration * 1000)
        } else {
            return String(format:"%.2f s", duration)
        }
    }
    
    private static func timestamp() -> TimeMeasurementTimestamp {
        return CFAbsoluteTimeGetCurrent()
    }
}
