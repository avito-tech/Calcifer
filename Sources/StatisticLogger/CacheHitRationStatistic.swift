import Foundation

public struct CacheHitRationStatistic {
    public let entries: [CacheHitRationEntry]
    
    public init(entries: [CacheHitRationEntry]) {
        self.entries = entries
    }
    
    public var hitRate: Double {
        let hitEntries = entries.filter { $0.resolution == .hit }
        return Double(hitEntries.count / entries.count)
    }
}
