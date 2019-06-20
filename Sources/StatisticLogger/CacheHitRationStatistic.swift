import Foundation

public struct CacheHitRationStatistic {
    public let entries: [CacheHitRationEntry]
    
    public init(entries: [CacheHitRationEntry]) {
        self.entries = entries
    }
    
    public var hitRate: Double? {
        guard !entries.isEmpty else { return nil }
        let hitEntries = entries.filter { $0.resolution == .hit }
        let rate = Double(hitEntries.count) / Double(entries.count)
        return rate
    }
}
